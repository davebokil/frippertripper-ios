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
    ///
    /// `delaySamples` and every index are clamped defensively against the *current*
    /// `capacity`, not just derived from it - `prepare(sampleRate:)` can reallocate
    /// `buffer` (e.g. on session restart) while a stale `writeIndex` or an in-flight
    /// `delayTimeSeconds` briefly reflects the old size; a real crash (index out of
    /// range here) was traced to exactly that race. Belt-and-suspenders even though
    /// the actual trigger was fixed at the call site.
    func process(input: Float, delayTimeSeconds: Float, feedbackGain: Float) -> Float {
        let capacity = buffer.count
        guard capacity > 1 else { return 0 }

        let maxDelaySamples = Double(capacity - 2)
        let delaySamples = min(max(Double(delayTimeSeconds) * sampleRate, 0), maxDelaySamples)
        let safeWriteIndex = min(max(writeIndex, 0), capacity - 1)

        let readPosition = Double(safeWriteIndex) - delaySamples
        var wrapped = readPosition.truncatingRemainder(dividingBy: Double(capacity))
        if wrapped < 0 { wrapped += Double(capacity) }

        let index0 = min(max(Int(wrapped), 0), capacity - 1)
        let index1 = (index0 + 1) % capacity
        let frac = Float(wrapped - Double(index0))
        let delayed = buffer[index0] * (1 - frac) + buffer[index1] * frac

        buffer[safeWriteIndex] = input + feedbackGain * delayed
        writeIndex = (safeWriteIndex + 1) % capacity

        return delayed
    }
}
