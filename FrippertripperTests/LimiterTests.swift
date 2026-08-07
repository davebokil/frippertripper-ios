import XCTest
@testable import Frippertripper

final class LimiterTests: XCTestCase {
    private let sampleRate: Double = 44100

    func testSignalBelowThresholdPassesThroughUnchanged() {
        let limiter = Limiter()
        limiter.prepare(sampleRate: sampleRate)

        var lastOutput: Float = 0
        for _ in 0..<4096 {
            lastOutput = limiter.process(input: 0.1, thresholdDb: -3)
        }

        XCTAssertEqual(lastOutput, 0.1, accuracy: 0.001)
        XCTAssertEqual(limiter.currentReductionDb, 0, accuracy: 0.01)
    }

    func testSignalAboveThresholdIsAttenuated() {
        let limiter = Limiter()
        limiter.prepare(sampleRate: sampleRate)

        // Constant loud input, well above threshold; let the attack settle
        // (attack = 1ms, so a few hundred samples is plenty).
        var lastOutput: Float = 0
        for _ in 0..<4096 {
            lastOutput = limiter.process(input: 0.9, thresholdDb: -6)
        }

        XCTAssertLessThan(abs(lastOutput), 0.9, "output should be attenuated below the unprocessed input level")
        XCTAssertLessThan(limiter.currentReductionDb, 0)
    }

    func testReductionNeverPositive() {
        let limiter = Limiter()
        limiter.prepare(sampleRate: sampleRate)

        for i in 0..<8192 {
            let input = Float(sin(Double(i) * 0.1)) * (i % 2000 < 1000 ? 0.05 : 0.95)
            _ = limiter.process(input: input, thresholdDb: -3)
            XCTAssertLessThanOrEqual(limiter.currentReductionDb, 0.0001)
            XCTAssertTrue(limiter.currentReductionDb.isFinite)
        }
    }

    func testOutputStaysFiniteAcrossExtremeInputs() {
        let limiter = Limiter()
        limiter.prepare(sampleRate: sampleRate)

        for input: Float in [0, 0.001, 1.0, 5.0, -5.0] {
            let output = limiter.process(input: input, thresholdDb: -3)
            XCTAssertTrue(output.isFinite)
        }
    }
}
