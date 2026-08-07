import Foundation

/// Port of `public/worklets/sh101-voice-processor.js`: PolyBLEP band-limited
/// saw + variable-width pulse, a phase-locked digital sub-oscillator, noise, the
/// 4-input source mixer, and the shared LFO (all 4 waveforms). `render(...)` is a
/// pure function of its arguments plus the persistent phase/wrap/RNG state below —
/// mode switches (pwmSource, subMode, lfoWaveform, lfoToPitchOn) are passed in by the
/// caller each call rather than stored here, so this type stays independently testable.
final class Oscillator: @unchecked Sendable {
    private var phase: Double = 0
    private var mainWrapCount: Int = 0
    private var lfoPhase: Double = 0
    private var lfoPrevPhase: Double = 0
    private var lfoShValue: Float = 0
    private var rng: Xorshift32
    private var sampleRate: Double = 44100

    static let lfoToPitchSemitones: Float = 12
    static let pwmEnvDepth: Float = 0.45
    static let pwmLfoDepth: Float = 0.45
    static let mixerHeadroom: Float = 0.5

    init(seed: UInt32 = 0xC0FFEE) {
        rng = Xorshift32(seed: seed)
    }

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
        phase = 0
        mainWrapCount = 0
        lfoPhase = 0
        lfoPrevPhase = 0
    }

    struct Sample {
        var audio: Float
        var lfo: Float
    }

    func render(
        frequency: Float,
        pulseWidth: Float,
        mixSawLevel: Float,
        mixPulseLevel: Float,
        mixSubLevel: Float,
        mixNoiseLevel: Float,
        pwmEnvIn: Float,
        lfoRate: Float,
        lfoDepth: Float,
        pwmSource: PwmSource,
        subMode: SubMode,
        lfoWaveform: LfoWaveform,
        lfoToPitchOn: Bool
    ) -> Sample {
        // --- LFO (drives its own output, and optionally this oscillator's pitch/PWM) ---
        let lfoDt = Double(lfoRate) / sampleRate
        let lfoWrapped = lfoPhase < lfoPrevPhase
        let lfoValue = lfoValue(phase: lfoPhase, wrapped: lfoWrapped, waveform: lfoWaveform)
        lfoPrevPhase = lfoPhase
        lfoPhase += lfoDt
        if lfoPhase >= 1 { lfoPhase -= 1 }

        let depth = lfoDepth

        // --- VCO pitch (vibrato modulates phase increment, not phase itself - click-free) ---
        let vibratoRatio: Double = lfoToPitchOn
            ? pow(2.0, Double(lfoValue * depth * Self.lfoToPitchSemitones) / 12.0)
            : 1.0
        let freq = Double(frequency) * vibratoRatio
        let dt = max(freq, 0) / sampleRate

        // --- PWM source select ---
        var pwMod: Float = 0
        switch pwmSource {
        case .env: pwMod = pwmEnvIn * Self.pwmEnvDepth
        case .lfo: pwMod = lfoValue * depth * Self.pwmLfoDepth
        case .manual: break
        }
        let pw = Double(min(max(pulseWidth + pwMod, 0.02), 0.98))

        // --- sawtooth (PolyBLEP band-limited) ---
        var saw = Float(2 * phase - 1)
        saw -= polyBlep(phase, dt)

        // --- pulse (PolyBLEP band-limited, variable width) ---
        var pulse: Float = phase < pw ? 1 : -1
        pulse += polyBlep(phase, dt)
        pulse -= polyBlep((phase - pw + 1).truncatingRemainder(dividingBy: 1), dt)

        // --- sub-oscillator: phase-locked digital divider off the main oscillator's cycles ---
        let sub = subOscValue(subMode: subMode)

        // --- noise ---
        let noise = rng.nextUnit() * 2 - 1

        let audio = Self.mixerHeadroom * (
            mixSawLevel * saw +
            mixPulseLevel * pulse +
            mixSubLevel * sub +
            mixNoiseLevel * noise
        )

        // --- advance main VCO phase, detect wrap for the sub-osc divider ---
        phase += dt
        if phase >= 1 {
            phase -= 1
            mainWrapCount = (mainWrapCount + 1) % 4
        }

        return Sample(audio: audio, lfo: lfoValue)
    }

    private func lfoValue(phase: Double, wrapped: Bool, waveform: LfoWaveform) -> Float {
        switch waveform {
        case .square:
            return phase < 0.5 ? 1 : -1
        case .sh:
            if wrapped { lfoShValue = rng.nextUnit() * 2 - 1 }
            return lfoShValue
        case .noise:
            return rng.nextUnit() * 2 - 1
        case .triangle:
            return phase < 0.5 ? Float(4 * phase - 1) : Float(3 - 4 * phase)
        }
    }

    private func subOscValue(subMode: SubMode) -> Float {
        switch subMode {
        case .minus2Square: return (mainWrapCount / 2) % 2 == 0 ? 1 : -1
        case .minus2Pulse: return mainWrapCount % 4 == 0 ? 1 : -1
        case .minus1Square: return mainWrapCount % 2 == 0 ? 1 : -1
        }
    }
}

/// @param t phase in [0,1)  @param dt phase increment per sample
private func polyBlep(_ t: Double, _ dt: Double) -> Float {
    if t < dt {
        let x = t / dt
        return Float(x + x - x * x - 1)
    } else if t > 1 - dt {
        let x = (t - 1) / dt
        return Float(x * x + x + x + 1)
    }
    return 0
}
