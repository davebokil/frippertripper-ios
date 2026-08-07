import Foundation

/// Hand-rolled circular-buffer feedback delay, standing in for the source's
/// `DelayNode` + feedback `GainNode` loop (`voiceBus -> delayNode -> feedbackGain ->
/// delayNode` self-loop, `delayNode -> wetGain -> masterGain`). Linear-interpolated
/// fractional read matches `DelayNode`'s built-in interpolation, needed since
/// `echoTime` is continuously variable rather than snapping to whole samples.
///
/// `process(_:)` only returns the wet (delayed) tap - dry/wet mixing happens one
/// level up in `SynthEngineCore`, mirroring the source's parallel dry/wet gain nodes
/// both fed directly from `voiceBus`.
final class DelayLine: @unchecked Sendable {
    static let maxDelaySeconds: Double = 4

    private var buffer: [Float] = []
    private var writeIndex = 0
    private var sampleRate: Double = 44100

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
        let capacity = Int(Self.maxDelaySeconds * sampleRate) + 2
        buffer = [Float](repeating: 0, count: capacity)
        writeIndex = 0
    }

    /// Writes `input + feedbackGain * delayedRead` into the ring buffer and returns
    /// the delayed sample read `delayTimeSeconds` behind the write head.
    func process(input: Float, delayTimeSeconds: Float, feedbackGain: Float) -> Float {
        let capacity = buffer.count
        guard capacity > 0 else { return 0 }

        let delaySamples = Double(delayTimeSeconds) * sampleRate
        let readPosition = Double(writeIndex) - delaySamples
        var wrapped = readPosition.truncatingRemainder(dividingBy: Double(capacity))
        if wrapped < 0 { wrapped += Double(capacity) }

        let index0 = Int(wrapped)
        let index1 = (index0 + 1) % capacity
        let frac = Float(wrapped - Double(index0))
        let delayed = buffer[index0] * (1 - frac) + buffer[index1] * frac

        buffer[writeIndex] = input + feedbackGain * delayed
        writeIndex = (writeIndex + 1) % capacity

        return delayed
    }
}
