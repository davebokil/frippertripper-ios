import XCTest
@testable import Frippertripper

/// Regression test for a real crash: `AVAudioSourceNode`'s render block runs on
/// Core Audio's real-time thread, but a closure literal formed inside a plain method
/// of an `@MainActor` class can be inferred as MainActor-isolated depending on the
/// module's default-isolation setting. If that happens, the Swift runtime's actor
/// isolation assertion fires the instant the render thread calls it (SIGTRAP /
/// `dispatch_assert_queue_fail`), since that thread is never the main thread. This
/// actually starts the engine so real render callbacks fire from the real audio
/// thread, reproducing the crash if the fix (`AudioEngineController.makeRenderBlock`
/// being `nonisolated`) ever regresses.
@MainActor
final class AudioEngineControllerTests: XCTestCase {
    func testEngineStartAndNotePlaybackDoNotCrashOnRealtimeThread() async throws {
        let controller = AudioEngineController()
        controller.start()
        XCTAssertTrue(controller.isRunning)

        // Give the real-time thread several render callbacks to execute.
        try await Task.sleep(nanoseconds: 300_000_000)

        controller.core.noteOn(id: 0, frequency: 220)
        try await Task.sleep(nanoseconds: 300_000_000)
        controller.core.noteOff(id: 0)
        try await Task.sleep(nanoseconds: 100_000_000)

        controller.stop()
        XCTAssertFalse(controller.isRunning)
    }
}
