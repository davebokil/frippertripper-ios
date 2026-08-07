import Foundation

/// Shared linear-ramp ADSR generator, advanced once per sample. Collapses the source
/// app's three separately-scheduled `AudioParam` ramp chains (VCF `envIn`, VCO
/// `pwmEnvIn`, VCA gain) into one normalized (peak = 1) generator — SynthEngineCore
/// reads its `value` for the filter/PWM envelope inputs directly, and scales it by
/// `MONO_VOICE_PEAK` for the VCA when `vcaMode == .env`.
///
/// Both `triggerAttack` and `triggerRelease` start their ramp from whatever the
/// current value is (not from 0), matching the source's `setValueAtTime(param.value,
/// now)` — this is what makes legato retriggers smooth instead of clicking back to
/// silence first.
final class Envelope: @unchecked Sendable {
    private enum Stage {
        case idle, attack, decay, sustainStage, release
    }

    private(set) var value: Float = 0
    private var stage: Stage = .idle

    private var rampStartValue: Float = 0
    private var rampTargetValue: Float = 0
    private var totalSamples: Int = 1
    private var elapsedSamples: Int = 0

    private var pendingDecayDuration: Double = 0
    private var pendingDecayTarget: Float = 0

    private var sampleRate: Double = 44100

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
    }

    func triggerAttack(attack: Double, decay: Double, sustain: Float, peak: Float) {
        beginRamp(to: peak, duration: attack)
        pendingDecayDuration = decay
        pendingDecayTarget = peak * sustain
        stage = .attack
    }

    func triggerRelease(release: Double) {
        beginRamp(to: 0, duration: release)
        stage = .release
    }

    private func beginRamp(to target: Float, duration: Double) {
        rampStartValue = value
        rampTargetValue = target
        totalSamples = max(Int(duration * sampleRate), 1)
        elapsedSamples = 0
    }

    @discardableResult
    func advance() -> Float {
        switch stage {
        case .idle, .sustainStage:
            break

        case .attack:
            step { self.beginStage(.decay, to: self.pendingDecayTarget, duration: self.pendingDecayDuration) }

        case .decay:
            step { self.stage = .sustainStage }

        case .release:
            step { self.stage = .idle }
        }
        return value
    }

    private func beginStage(_ next: Stage, to target: Float, duration: Double) {
        beginRamp(to: target, duration: duration)
        stage = next
    }

    private func step(onComplete: () -> Void) {
        elapsedSamples += 1
        let t = Float(elapsedSamples) / Float(totalSamples)
        if t >= 1 {
            value = rampTargetValue
            onComplete()
        } else {
            value = rampStartValue + (rampTargetValue - rampStartValue) * t
        }
    }
}
