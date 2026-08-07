import Foundation

private enum EngineCommand {
    case noteOn(id: Int, freq: Float)
    case noteOff(id: Int)
}

/// The fused monophonic voice chain: VCO+LFO -> VCF -> shared ADSR -> VCA -> dry/wet
/// echo -> master gain -> limiter -> ceiling, entirely inside one per-sample loop (see
/// the plan's "fuse the whole signal chain" decision — this sidesteps
/// `AVAudioSourceNode` having no audio input bus, which is what would otherwise force
/// a literal multi-node port of the source's Web Audio graph).
///
/// Has zero AVFoundation dependency, so it's directly exercisable by plain XCTest.
///
/// Thread-safety model: continuous/discrete parameters are plain stored properties,
/// written from the UI thread and read from the render thread — per SynthEngineCore's
/// documented rationale (see RampedParameter/CommandQueue), single/few-word writes on
/// arm64 don't tear, so brief cross-thread inconsistency (at most one sample's worth)
/// is an accepted trade-off for lock-freedom. Note on/off events mutate `heldNotes`
/// (an array, not safely word-atomic), so those go through `CommandQueue` instead.
final class SynthEngineCore: @unchecked Sendable {
    static let monoVoicePeak: Float = 0.7
    static let keyFollowReferenceFreq: Float = 261.6256 // C4
    static let maxFeedback: Float = 0.97
    static let masterGain: Float = 0.85

    private let oscillator = Oscillator()
    private let filter = LadderFilter()
    private let sharedEnvelope = Envelope()
    private let delayLine = DelayLine()
    private let limiter = Limiter()
    private let commandQueue = CommandQueue<EngineCommand>(capacity: 64)

    private var sampleRate: Double = 44100

    // Monophonic last-note-priority stack. Touched only from the render thread
    // (inside `render`, via drained commands), so plain Array mutation is safe here.
    private var heldNotes: [(id: Int, freq: Float)] = []
    private var vcaGateOpen = false

    // --- VCO/mixer/filter glide targets (Web Audio AudioParam equivalents) ---
    private let frequencyParam = RampedParameter(220)
    private let cutoffBaseParam = RampedParameter(3500)

    // --- Smoothed continuous parameters (equivalent to the source's setTargetAtTime
    // watchers, tau = 0.01s unless noted) ---
    let vcoPulseWidthParam = RampedParameter(0.5)
    let mixSawLevelParam = RampedParameter(0)
    let mixPulseLevelParam = RampedParameter(0.7)
    let mixSubLevelParam = RampedParameter(0)
    let mixNoiseLevelParam = RampedParameter(0)
    let filterResonanceParam = RampedParameter(0.3)
    let filterEnvAmountParam = RampedParameter(0)
    let lfoRateParam = RampedParameter(5)
    let lfoDepthParam = RampedParameter(0)

    // --- Echo (delay) and limiter, downstream of the voice. Each setter below
    // performs the same one-time mapping the source computes in its `watch()`
    // callback before smoothing the *mapped* value, matching exactly which quantity
    // gets the `setTargetAtTime` treatment (e.g. the delay's raw 0-1 slider is mapped
    // through `feedbackFromSlider` once, then the resulting gain is what's smoothed -
    // not the raw slider value). ---
    private let dryGainParam = RampedParameter(SynthEngineCore.dryWetGains(0.3).dry)
    private let wetGainParam = RampedParameter(SynthEngineCore.dryWetGains(0.3).wet)
    private let echoTimeParam = RampedParameter(0.35)
    private let echoFeedbackGainParam = RampedParameter(SynthEngineCore.feedbackFromSlider(0.4))
    private let limiterThresholdParam = RampedParameter(-3)
    private let ceilingGainParam = RampedParameter(SynthEngineCore.dbToGain(0))

    /// Current gain reduction in dB (<= 0), matching the source's read of
    /// `compressor.reduction`. Single-word read, safe from the UI thread at ~30-60Hz
    /// for a GR meter under the same thread-safety rationale as the rest of this type.
    var limiterReductionDb: Float { limiter.currentReductionDb }

    // --- Discrete/raw parameters (unsmoothed, matching the source's postMessage /
    // plain-assignment fields) ---
    var vcoRange: VcoRange = .eight
    var vcoTune: Float = 0 // cents
    var vcoPwmSource: PwmSource = .manual
    var mixSubMode: SubMode = .minus1Square
    var filterCutoffKnob: Float = 3500 // Hz, the raw knob value (pre key-follow/bender)
    var filterKeyFollow: Float = 0
    var filterLfoOn = false
    var vcaMode: VcaMode = .env
    var lfoWaveform: LfoWaveform = .triangle
    var lfoToPitchOn = false
    var benderPosition: Float = 0
    var benderVcoSens: Float = 2 // semitones
    var benderVcfSens: Float = 0 // octaves
    var portamentoTime: Float = 0.15
    var portamentoOn = false
    var attackSeconds: Float = 0.02
    var decaySeconds: Float = 0.15
    var sustainLevel: Float = 0.7
    var releaseSeconds: Float = 0.3

    // Last-seen values of the "live retune" watch group (mirrors the source's
    // `watch([vcoRange, vcoTune, benderPosition, benderVcoSens, benderVcfSens,
    // filterCutoff, filterKeyFollow], retuneHeldVoiceLive)`), checked once per render
    // block so a change while a note is held snaps pitch/cutoff via a fast
    // `setTargetAtTime`-style retune rather than fighting an in-flight portamento glide.
    private var lastVcoRange: VcoRange = .eight
    private var lastVcoTune: Float = 0
    private var lastBenderPosition: Float = 0
    private var lastBenderVcoSens: Float = 2
    private var lastBenderVcfSens: Float = 0
    private var lastFilterCutoffKnob: Float = 3500
    private var lastFilterKeyFollow: Float = 0

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
        oscillator.prepare(sampleRate: sampleRate)
        filter.prepare(sampleRate: sampleRate)
        sharedEnvelope.prepare(sampleRate: sampleRate)
        delayLine.prepare(sampleRate: sampleRate)
        limiter.prepare(sampleRate: sampleRate)
        frequencyParam.prepare(sampleRate: sampleRate)
        cutoffBaseParam.prepare(sampleRate: sampleRate)
        for param in smoothedParams { param.prepare(sampleRate: sampleRate) }
    }

    private var smoothedParams: [RampedParameter] {
        [vcoPulseWidthParam, mixSawLevelParam, mixPulseLevelParam, mixSubLevelParam,
         mixNoiseLevelParam, filterResonanceParam, filterEnvAmountParam, lfoRateParam, lfoDepthParam,
         dryGainParam, wetGainParam, echoTimeParam, echoFeedbackGainParam, limiterThresholdParam, ceilingGainParam]
    }

    // MARK: - Note events (UI thread)

    func noteOn(id: Int, frequency: Float) {
        commandQueue.push(.noteOn(id: id, freq: frequency))
    }

    func noteOff(id: Int) {
        commandQueue.push(.noteOff(id: id))
    }

    // MARK: - Echo/limiter setters (UI thread)

    /// 0 = dry only, 1 = wet only (equal-power crossfade).
    func setEchoVolume(_ value: Float) {
        let (dry, wet) = Self.dryWetGains(value)
        dryGainParam.setTarget(dry, tau: 0.02)
        wetGainParam.setTarget(wet, tau: 0.02)
    }

    /// Delay time in seconds, 0...MAX_DELAY.
    func setEchoTime(_ value: Float) {
        echoTimeParam.setTarget(value, tau: 0.05)
    }

    /// Raw 0-1 repeat slider; mapped through `feedbackFromSlider` before smoothing.
    func setEchoRepeat(_ value: Float) {
        echoFeedbackGainParam.setTarget(Self.feedbackFromSlider(value), tau: 0.05)
    }

    /// dBFS, -24...0.
    func setLimiterThreshold(_ db: Float) {
        limiterThresholdParam.setTarget(db, tau: 0.01)
    }

    /// dBFS, -24...0; mapped through `dbToGain` before smoothing.
    func setLimiterCeiling(_ db: Float) {
        ceilingGainParam.setTarget(Self.dbToGain(db), tau: 0.02)
    }

    // MARK: - Render (audio thread)

    func render(frameCount: Int, into buffer: UnsafeMutablePointer<Float>) {
        commandQueue.drain { [self] command in
            switch command {
            case .noteOn(let id, let freq): handleNoteOn(id: id, freq: freq)
            case .noteOff(let id): handleNoteOff(id: id)
            }
        }

        applyLiveRetuneIfNeeded()

        for frame in 0..<frameCount {
            buffer[frame] = renderSample()
        }
    }

    private func renderSample() -> Float {
        let freq = frequencyParam.advance()
        let cutoffBase = cutoffBaseParam.advance()

        let pulseWidth = vcoPulseWidthParam.advance()
        let mixSaw = mixSawLevelParam.advance()
        let mixPulse = mixPulseLevelParam.advance()
        let mixSub = mixSubLevelParam.advance()
        let mixNoise = mixNoiseLevelParam.advance()
        let resonance = filterResonanceParam.advance()
        let envAmount = filterEnvAmountParam.advance()
        let rate = lfoRateParam.advance()
        let depth = lfoDepthParam.advance()

        let envValue = sharedEnvelope.advance()

        let osc = oscillator.render(
            frequency: freq,
            pulseWidth: pulseWidth,
            mixSawLevel: mixSaw,
            mixPulseLevel: mixPulse,
            mixSubLevel: mixSub,
            mixNoiseLevel: mixNoise,
            pwmEnvIn: envValue,
            lfoRate: rate,
            lfoDepth: depth,
            pwmSource: vcoPwmSource,
            subMode: mixSubMode,
            lfoWaveform: lfoWaveform,
            lfoToPitchOn: lfoToPitchOn
        )

        let filtered = filter.process(
            input: osc.audio,
            cutoffBase: cutoffBase,
            resonance: resonance,
            envAmount: envAmount,
            envIn: envValue,
            lfoDepth: depth,
            lfoIn: osc.lfo,
            filterLfoOn: filterLfoOn
        )

        let vcaGain: Float = vcaMode == .env
            ? envValue * Self.monoVoicePeak
            : (vcaGateOpen ? Self.monoVoicePeak : 0)

        let voiceOut = filtered * vcaGain

        // --- echo (dry/wet mix around the feedback delay line) ---
        let dryGain = dryGainParam.advance()
        let wetGain = wetGainParam.advance()
        let delayTime = echoTimeParam.advance()
        let feedbackGain = echoFeedbackGainParam.advance()
        let wetSample = delayLine.process(input: voiceOut, delayTimeSeconds: delayTime, feedbackGain: feedbackGain)

        let mixed = (voiceOut * dryGain + wetSample * wetGain) * Self.masterGain

        // --- limiter, sitting after the dry+echo mix so it limits the full signal
        // including echo repeats, then a separate ceiling trim stage ---
        let thresholdDb = limiterThresholdParam.advance()
        let limited = limiter.process(input: mixed, thresholdDb: thresholdDb)
        let ceiling = ceilingGainParam.advance()

        return limited * ceiling
    }

    // MARK: - Monophonic note stack (render thread only)

    private func handleNoteOn(id: Int, freq: Float) {
        heldNotes.removeAll { $0.id == id }
        heldNotes.append((id: id, freq: freq))
        attack(freq: freq)
    }

    private func handleNoteOff(id: Int) {
        heldNotes.removeAll { $0.id == id }
        if let top = heldNotes.last {
            attack(freq: top.freq)
        } else {
            release()
        }
    }

    private func attack(freq: Float) {
        glide(to: freq)
        sharedEnvelope.triggerAttack(
            attack: Double(max(attackSeconds, 0.001)),
            decay: Double(max(decaySeconds, 0.001)),
            sustain: sustainLevel,
            peak: 1
        )
        if vcaMode == .gate { vcaGateOpen = true }
    }

    private func release() {
        sharedEnvelope.triggerRelease(release: Double(max(releaseSeconds, 0.001)))
        if vcaMode == .gate { vcaGateOpen = false }
    }

    private func glide(to freq: Float) {
        let freqTarget = computeVcoFrequency(freq: freq)
        let cutoffTarget = computeCutoffBase(freq: freq)

        if portamentoOn {
            let duration = Double(max(portamentoTime, 0.001))
            frequencyParam.rampExponential(to: max(freqTarget, 0.01), duration: duration)
            cutoffBaseParam.rampExponential(to: max(cutoffTarget, 20), duration: duration)
        } else {
            frequencyParam.setImmediate(freqTarget)
            cutoffBaseParam.setImmediate(cutoffTarget)
        }
    }

    private func applyLiveRetuneIfNeeded() {
        defer {
            lastVcoRange = vcoRange
            lastVcoTune = vcoTune
            lastBenderPosition = benderPosition
            lastBenderVcoSens = benderVcoSens
            lastBenderVcfSens = benderVcfSens
            lastFilterCutoffKnob = filterCutoffKnob
            lastFilterKeyFollow = filterKeyFollow
        }

        guard let top = heldNotes.last else { return }

        let changed = vcoRange != lastVcoRange
            || vcoTune != lastVcoTune
            || benderPosition != lastBenderPosition
            || benderVcoSens != lastBenderVcoSens
            || benderVcfSens != lastBenderVcfSens
            || filterCutoffKnob != lastFilterCutoffKnob
            || filterKeyFollow != lastFilterKeyFollow
        guard changed else { return }

        frequencyParam.setTarget(computeVcoFrequency(freq: top.freq), tau: 0.01)
        cutoffBaseParam.setTarget(computeCutoffBase(freq: top.freq), tau: 0.01)
    }

    private func computeVcoFrequency(freq: Float) -> Float {
        let rangeMultiplier = pow(2, vcoRange.octaveOffset)
        let tuneMultiplier = pow(2, vcoTune / 1200)
        let benderMultiplier = pow(2, (benderPosition * benderVcoSens) / 12)
        return freq * rangeMultiplier * tuneMultiplier * benderMultiplier
    }

    private func computeCutoffBase(freq: Float) -> Float {
        let keyFollowMultiplier = pow(freq / Self.keyFollowReferenceFreq, filterKeyFollow)
        let benderMultiplier = pow(2, benderPosition * benderVcfSens)
        return filterCutoffKnob * keyFollowMultiplier * benderMultiplier
    }

    // MARK: - Static DSP-mapping helpers (echo/limiter)

    /// Equal-power dry/wet crossfade: `(cos(mix*pi/2), sin(mix*pi/2))`.
    static func dryWetGains(_ mix: Float) -> (dry: Float, wet: Float) {
        let angle = mix * (Float.pi / 2)
        return (cos(angle), sin(angle))
    }

    /// Eases the raw 0-1 repeat slider toward `maxFeedback` so the top of the slider
    /// (near-"infinite" repeat) gets finer control.
    static func feedbackFromSlider(_ value: Float) -> Float {
        maxFeedback * (1 - pow(1 - value, 2))
    }

    static func dbToGain(_ db: Float) -> Float {
        pow(10, db / 20)
    }
}
