import Foundation

/// Hand-rolled output-stage limiter, standing in for the source's
/// `DynamicsCompressorNode` (there's no direct AVAudioEngine equivalent). Matches its
/// configured constants exactly: `knee = 0` (hard knee), `ratio = 20`,
/// `attack = 0.001s`, `release = 0.25s`. A feed-forward peak detector computes
/// instantaneous gain reduction from the input level vs. threshold, then an
/// asymmetric attack/release one-pole smooths the *reduction* itself (fast attack to
/// catch transients, slow release to avoid pumping) - this is what
/// `currentReductionDb` reports for the GR meter, matching the source's read of
/// `compressor.reduction` each animation frame.
final class Limiter: @unchecked Sendable {
    static let ratio: Float = 20
    static let attackSeconds: Float = 0.001
    static let releaseSeconds: Float = 0.25

    private var sampleRate: Double = 44100
    private var attackCoefficient: Float = 1
    private var releaseCoefficient: Float = 1
    private var appliedReductionDb: Float = 0

    private(set) var currentReductionDb: Float = 0

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
        attackCoefficient = Float(1 - exp(-1.0 / (Double(Self.attackSeconds) * sampleRate)))
        releaseCoefficient = Float(1 - exp(-1.0 / (Double(Self.releaseSeconds) * sampleRate)))
        appliedReductionDb = 0
        currentReductionDb = 0
    }

    func process(input: Float, thresholdDb: Float) -> Float {
        let inputLevelDb = 20 * log10(max(abs(input), 1e-6))

        let instantaneousReductionDb: Float = inputLevelDb > thresholdDb
            ? (inputLevelDb - thresholdDb) * (1 - 1 / Self.ratio)
            : 0

        let coefficient = instantaneousReductionDb > appliedReductionDb ? attackCoefficient : releaseCoefficient
        appliedReductionDb += (instantaneousReductionDb - appliedReductionDb) * coefficient

        currentReductionDb = -appliedReductionDb
        let gain = pow(10, -appliedReductionDb / 20)
        return input * gain
    }
}
