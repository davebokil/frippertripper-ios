import Foundation
import Observation

/// The Swift analog of the source's "module-singleton refs + `watch()` push into the
/// audio graph" pattern (`app/composables/useAudioEngine.ts`): one `@Observable`
/// instance, owned by the root view and passed down explicitly, exposing the full
/// ~35-parameter surface as plain properties. Each `didSet` forwards the change into
/// `SynthEngineCore` — either a direct assignment (discrete params) or a smoothed
/// `RampedParameter.setTarget` call (continuous params, tau = 0.01s to match the
/// source's default `setTargetAtTime` smoothing).
@MainActor
@Observable
final class SynthEngine {
    let audioEngineController = AudioEngineController()
    var core: SynthEngineCore { audioEngineController.core }

    // MARK: - VCO
    var vcoRange: VcoRange = .eight { didSet { core.vcoRange = vcoRange } }
    var vcoTune: Float = 0 { didSet { core.vcoTune = vcoTune } }
    var vcoPulseWidth: Float = 0.5 { didSet { core.vcoPulseWidthParam.setTarget(vcoPulseWidth, tau: 0.01) } }
    var vcoPwmSource: PwmSource = .manual { didSet { core.vcoPwmSource = vcoPwmSource } }

    // MARK: - Source mixer
    var mixSawLevel: Float = 0.45 { didSet { core.mixSawLevelParam.setTarget(mixSawLevel, tau: 0.01) } }
    var mixPulseLevel: Float = 0.45 { didSet { core.mixPulseLevelParam.setTarget(mixPulseLevel, tau: 0.01) } }
    var mixSubLevel: Float = 0.4 { didSet { core.mixSubLevelParam.setTarget(mixSubLevel, tau: 0.01) } }
    var mixNoiseLevel: Float = 0 { didSet { core.mixNoiseLevelParam.setTarget(mixNoiseLevel, tau: 0.01) } }
    var mixSubMode: SubMode = .minus1Square { didSet { core.mixSubMode = mixSubMode } }

    // MARK: - Filter
    var filterCutoff: Float = 3500 { didSet { core.filterCutoffKnob = filterCutoff } }
    var filterResonance: Float = 0.3 { didSet { core.filterResonanceParam.setTarget(filterResonance, tau: 0.01) } }
    var filterEnvAmount: Float = 0 { didSet { core.filterEnvAmountParam.setTarget(filterEnvAmount, tau: 0.01) } }
    var filterLfoOn = false { didSet { core.filterLfoOn = filterLfoOn } }
    var filterKeyFollow: Float = 0 { didSet { core.filterKeyFollow = filterKeyFollow } }

    // MARK: - Envelope (shared by filter/PWM/VCA)
    var attack: Float = 0.02 { didSet { core.attackSeconds = attack } }
    var decay: Float = 0.15 { didSet { core.decaySeconds = decay } }
    var sustain: Float = 0.7 { didSet { core.sustainLevel = sustain } }
    var release: Float = 0.3 { didSet { core.releaseSeconds = release } }

    // MARK: - VCA
    var vcaMode: VcaMode = .env { didSet { core.vcaMode = vcaMode } }

    // MARK: - LFO
    var lfoWaveform: LfoWaveform = .triangle { didSet { core.lfoWaveform = lfoWaveform } }
    var lfoRate: Float = 5 { didSet { core.lfoRateParam.setTarget(lfoRate, tau: 0.01) } }
    var lfoDepth: Float = 0 { didSet { core.lfoDepthParam.setTarget(lfoDepth, tau: 0.01) } }
    var lfoToPitchOn = false { didSet { core.lfoToPitchOn = lfoToPitchOn } }

    // MARK: - Arpeggiator
    var arpMode: ArpMode = .off { didSet { core.arpMode = arpMode } }
    var arpOctaves: Int = 1 { didSet { core.arpOctaves = arpOctaves } }
    var arpHold = false { didSet { core.arpHold = arpHold } }
    var arpRate: Float = 5 { didSet { core.arpRate = arpRate } }

    // MARK: - Controller
    var benderPosition: Float = 0 { didSet { core.benderPosition = benderPosition } }
    var benderVcoSens: Float = 2 { didSet { core.benderVcoSens = benderVcoSens } }
    var benderVcfSens: Float = 0 { didSet { core.benderVcfSens = benderVcfSens } }
    var portamentoTime: Float = 0.15 { didSet { core.portamentoTime = portamentoTime } }
    var portamentoOn = false { didSet { core.portamentoOn = portamentoOn } }

    // MARK: - Echo
    var echoVolume: Float = 0.3 { didSet { core.setEchoVolume(echoVolume) } }
    var echoTime: Float = 0.35 { didSet { core.setEchoTime(echoTime) } }
    var echoRepeat: Float = 0.4 { didSet { core.setEchoRepeat(echoRepeat) } }

    // MARK: - Limiter
    var limiterThreshold: Float = -3 { didSet { core.setLimiterThreshold(limiterThreshold) } }
    var limiterCeiling: Float = 0 { didSet { core.setLimiterCeiling(limiterCeiling) } }

    // MARK: - Note input

    /// Primes the engine (idempotent, matches the source's `primeAudioContext()`
    /// deferred-init pattern) and plays a note. Called from the piano keyboard.
    func noteOn(id: Int, frequency: Float) {
        audioEngineController.start()
        core.noteOn(id: id, frequency: frequency)
    }

    func noteOff(id: Int) {
        core.noteOff(id: id)
    }

    /// Cuts short any ringing echo repeats without touching the dry signal, held
    /// notes, or any front-panel setting.
    func clearEcho() {
        core.clearEcho()
    }

    // MARK: - Randomize

    /// Port of the source's `randomizeAll()`: randomizes every front-panel control
    /// (VCO through envelope, LFO, controller sensitivities) but deliberately leaves
    /// the echo/limiter rack, arp settings, live bender position, and note state
    /// untouched.
    func randomizeAll() {
        vcoRange = [.sixteen, .eight, .four, .two].randomElement()!
        vcoTune = .random(in: -50...50)
        vcoPulseWidth = .random(in: 0.02...0.98)
        vcoPwmSource = [.manual, .env, .lfo].randomElement()!

        mixSawLevel = .random(in: 0...1)
        mixPulseLevel = .random(in: 0...1)
        mixSubLevel = .random(in: 0...1)
        mixNoiseLevel = .random(in: 0...1)
        mixSubMode = [.minus1Square, .minus2Square, .minus2Pulse].randomElement()!

        filterCutoff = randLog(80, 12000)
        filterResonance = .random(in: 0...0.8)
        filterEnvAmount = .random(in: -1...1)
        filterLfoOn = Bool.random(probabilityTrue: 0.35)
        filterKeyFollow = .random(in: 0...1)

        attack = randLog(0.001, 3)
        decay = randLog(0.02, 3)
        sustain = .random(in: 0...1)
        release = randLog(0.02, 5)

        vcaMode = [.env, .gate].randomElement()!

        lfoWaveform = [.triangle, .square, .sh, .noise].randomElement()!
        lfoRate = randLog(0.1, 30)
        lfoDepth = .random(in: 0...0.6)
        lfoToPitchOn = Bool.random(probabilityTrue: 0.35)

        benderVcoSens = .random(in: 0...12)
        benderVcfSens = .random(in: 0...4)
        portamentoTime = randLog(0.02, 5)
        portamentoOn = Bool.random(probabilityTrue: 0.3)
    }

    // MARK: - Reset

    /// Restores every persistent parameter to its factory-default value, via the
    /// same `apply(_:)` path a saved preset uses.
    func resetToFactoryDefaults() {
        apply(.factoryDefault)
    }

    // MARK: - Session persistence

    /// Snapshots every persistent parameter (the same set `SynthPreset` models -
    /// front panel, echo, limiter; not bender position or UI/keyboard state) so the
    /// next launch can pick up where this session left off, regardless of whether
    /// the sound started from a saved preset or was hand-tweaked. Call on
    /// backgrounding, not on every parameter change - one write per session is
    /// enough and avoids hammering `UserDefaults` while a knob is being dragged.
    func saveSession() {
        guard let data = try? JSONEncoder().encode(makePreset(name: "")) else { return }
        UserDefaults.standard.set(data, forKey: Self.lastSessionKey)
    }

    /// Restores the last-saved session snapshot, if any (none exists on a fresh
    /// install, in which case this leaves the engine at its declared defaults).
    /// Call once at launch, before starting the audio engine.
    func restoreLastSession() {
        guard let data = UserDefaults.standard.data(forKey: Self.lastSessionKey),
              let preset = try? JSONDecoder().decode(SynthPreset.self, from: data) else { return }
        apply(preset)
    }

    private static let lastSessionKey = "com.davebokil.frippertripper.lastSession"

    private func randLog(_ min: Float, _ max: Float) -> Float {
        let lo = log(min), hi = log(max)
        return exp(lo + Float.random(in: 0...1) * (hi - lo))
    }
}

private extension Bool {
    static func random(probabilityTrue: Double) -> Bool {
        Double.random(in: 0..<1) < probabilityTrue
    }
}
