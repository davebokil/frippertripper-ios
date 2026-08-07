import XCTest
@testable import Frippertripper

final class DelayLineTests: XCTestCase {
    private let sampleRate: Double = 44100

    func testImpulseReturnsAtExpectedDelayWithoutFeedback() {
        let delay = DelayLine()
        delay.prepare(sampleRate: sampleRate)

        let delayTime: Float = 0.1
        let delaySamples = Int(Double(delayTime) * sampleRate)

        var output = [Float](repeating: 0, count: delaySamples + 10)
        for i in 0..<output.count {
            let input: Float = i == 0 ? 1 : 0
            output[i] = delay.process(input: input, delayTimeSeconds: delayTime, feedbackGain: 0)
        }

        // The impulse should reappear (via linear-interpolated read) right around
        // `delaySamples`, and be ~silent well before/after that.
        let peakIndex = output.indices.max(by: { output[$0] < output[$1] })!
        XCTAssertEqual(peakIndex, delaySamples, accuracy: 1)
        XCTAssertGreaterThan(output[peakIndex], 0.9)
        XCTAssertLessThan(abs(output[0]), 0.01)
    }

    func testFeedbackProducesDecayingRepeats() {
        let delay = DelayLine()
        delay.prepare(sampleRate: sampleRate)

        let delayTime: Float = 0.05
        let delaySamples = Int(Double(delayTime) * sampleRate)
        let feedback: Float = 0.5

        var output = [Float](repeating: 0, count: delaySamples * 4 + 2)
        for i in 0..<output.count {
            let input: Float = i == 0 ? 1 : 0
            output[i] = delay.process(input: input, delayTimeSeconds: delayTime, feedbackGain: feedback)
        }

        // Peak magnitude in a small window around each expected repeat.
        func peak(near sample: Int) -> Float {
            let window = output[max(0, sample - 1)...min(output.count - 1, sample + 1)]
            return window.map(abs).max() ?? 0
        }

        let repeat1 = peak(near: delaySamples)
        let repeat2 = peak(near: delaySamples * 2)
        let repeat3 = peak(near: delaySamples * 3)

        // Each repeat should be smaller than the previous (decaying feedback).
        XCTAssertLessThan(repeat2, repeat1)
        XCTAssertLessThan(repeat3, repeat2)
    }

    func testOutputStaysFiniteAndBoundedWithHighFeedback() {
        let delay = DelayLine()
        delay.prepare(sampleRate: sampleRate)

        var maxAbs: Float = 0
        for i in 0..<44100 {
            let input: Float = i < 100 ? 0.5 : 0
            let output = delay.process(input: input, delayTimeSeconds: 0.02, feedbackGain: 0.97)
            XCTAssertTrue(output.isFinite)
            maxAbs = max(maxAbs, abs(output))
        }
        XCTAssertLessThan(maxAbs, 20, "even near-max feedback (0.97, below unity) shouldn't blow up")
    }
}
