import Foundation

/// A sample-accurate stand-in for a Web Audio `AudioParam`, supporting the three
/// automation shapes the source engine relies on:
///   - `setImmediate`   ~= `setValueAtTime`            (instant jump)
///   - `rampLinear`     ~= `linearRampToValueAtTime`    (ADSR segments)
///   - `rampExponential`~= `exponentialRampToValueAtTime` (portamento glide)
///   - `setTarget`      ~= `setTargetAtTime`            (click-free live retune/knob smoothing)
///
/// `advance()` must be called exactly once per output sample, from the render thread.
/// Setters may be called from the UI thread; per SynthEngineCore's documented
/// thread-safety model, brief cross-thread inconsistency of the handful of words this
/// type holds is an accepted trade-off (matches the source app's own eventually-
/// consistent `postMessage`/`AudioParam` automation model) in exchange for zero
/// locks/allocations on the audio thread.
final class RampedParameter: @unchecked Sendable {
    private enum Mode {
        case idle
        case linear
        case exponential
        case target
    }

    private(set) var value: Float
    private var mode: Mode = .idle

    private var startValue: Float = 0
    private var targetValue: Float = 0
    private var totalSamples: Int = 1
    private var elapsedSamples: Int = 0
    private var targetCoefficient: Float = 1

    private var sampleRate: Double = 44100

    init(_ initial: Float) {
        value = initial
    }

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
    }

    func setImmediate(_ newValue: Float) {
        value = newValue
        mode = .idle
    }

    func rampLinear(to target: Float, duration: Double) {
        startValue = value
        targetValue = target
        totalSamples = max(Int(duration * sampleRate), 1)
        elapsedSamples = 0
        mode = .linear
    }

    /// `value` must be > 0 for an exponential ramp to be well-defined; callers clamp
    /// targets away from zero before calling (mirrors the source's `Math.max(x, floor)`
    /// guards ahead of `exponentialRampToValueAtTime`).
    func rampExponential(to target: Float, duration: Double) {
        startValue = max(value, 1e-6)
        targetValue = max(target, 1e-6)
        totalSamples = max(Int(duration * sampleRate), 1)
        elapsedSamples = 0
        mode = .exponential
    }

    func setTarget(_ target: Float, tau: Float) {
        targetValue = target
        targetCoefficient = tau > 0 ? Float(1 - exp(-1.0 / (Double(tau) * sampleRate))) : 1
        mode = .target
    }

    @discardableResult
    func advance() -> Float {
        switch mode {
        case .idle:
            break

        case .linear:
            elapsedSamples += 1
            let t = Float(elapsedSamples) / Float(totalSamples)
            if t >= 1 {
                value = targetValue
                mode = .idle
            } else {
                value = startValue + (targetValue - startValue) * t
            }

        case .exponential:
            elapsedSamples += 1
            let t = Float(elapsedSamples) / Float(totalSamples)
            if t >= 1 {
                value = targetValue
                mode = .idle
            } else {
                value = startValue * pow(targetValue / startValue, t)
            }

        case .target:
            value += (targetValue - value) * targetCoefficient
        }
        return value
    }
}
