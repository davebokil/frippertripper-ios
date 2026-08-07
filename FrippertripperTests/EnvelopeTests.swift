import XCTest
@testable import Frippertripper

final class EnvelopeTests: XCTestCase {
    private let sampleRate: Double = 44100

    func testAttackReachesPeak() {
        let env = Envelope()
        env.prepare(sampleRate: sampleRate)
        env.triggerAttack(attack: 0.01, decay: 0.1, sustain: 0.5, peak: 1)

        var last: Float = 0
        for _ in 0..<Int(0.01 * sampleRate) {
            last = env.advance()
        }
        XCTAssertEqual(last, 1, accuracy: 0.01)
    }

    func testDecayReachesSustainLevel() {
        let env = Envelope()
        env.prepare(sampleRate: sampleRate)
        let sustain: Float = 0.4
        env.triggerAttack(attack: 0.01, decay: 0.1, sustain: sustain, peak: 1)

        var last: Float = 0
        for _ in 0..<Int(0.2 * sampleRate) {
            last = env.advance()
        }
        XCTAssertEqual(last, sustain, accuracy: 0.01)
    }

    func testSustainHoldsUntilRelease() {
        let env = Envelope()
        env.prepare(sampleRate: sampleRate)
        env.triggerAttack(attack: 0.001, decay: 0.001, sustain: 0.6, peak: 1)
        for _ in 0..<Int(0.05 * sampleRate) { _ = env.advance() }

        let a = env.advance()
        let b = env.advance()
        XCTAssertEqual(a, b, accuracy: 0.0001)
        XCTAssertEqual(a, 0.6, accuracy: 0.01)
    }

    func testReleaseReachesZero() {
        let env = Envelope()
        env.prepare(sampleRate: sampleRate)
        env.triggerAttack(attack: 0.001, decay: 0.001, sustain: 0.6, peak: 1)
        for _ in 0..<Int(0.05 * sampleRate) { _ = env.advance() }

        env.triggerRelease(release: 0.05)
        var last: Float = 1
        for _ in 0..<Int(0.06 * sampleRate) {
            last = env.advance()
        }
        XCTAssertEqual(last, 0, accuracy: 0.01)
    }

    /// Retriggering (a new attack fired mid-decay/release) should start from the
    /// current value, not snap back to 0 first - matches the source's
    /// `setValueAtTime(param.value, now)` legato behavior.
    func testRetriggerStartsFromCurrentValueNotZero() {
        let env = Envelope()
        env.prepare(sampleRate: sampleRate)
        env.triggerAttack(attack: 0.001, decay: 0.001, sustain: 0.6, peak: 1)
        for _ in 0..<Int(0.05 * sampleRate) { _ = env.advance() }

        env.triggerRelease(release: 1.0) // slow release, so we can catch it mid-flight
        for _ in 0..<Int(0.01 * sampleRate) { _ = env.advance() }
        let midRelease = env.advance()
        XCTAssertGreaterThan(midRelease, 0.1, "should still be mid-release, not at 0")

        env.triggerAttack(attack: 0.001, decay: 0.001, sustain: 0.6, peak: 1)
        let firstSampleAfterRetrigger = env.advance()
        XCTAssertGreaterThan(
            firstSampleAfterRetrigger, midRelease - 0.05,
            "retrigger should ramp up from the in-flight release value, not jump down to 0 first"
        )
    }
}
