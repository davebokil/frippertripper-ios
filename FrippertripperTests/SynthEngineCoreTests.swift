import XCTest
@testable import Frippertripper

final class SynthEngineCoreTests: XCTestCase {
    private func makeCore() -> SynthEngineCore {
        let core = SynthEngineCore()
        core.prepare(sampleRate: 44100)
        return core
    }

    private func renderBlock(_ core: SynthEngineCore, frames: Int) -> [Float] {
        var buffer = [Float](repeating: 0, count: frames)
        buffer.withUnsafeMutableBufferPointer { ptr in
            core.render(frameCount: frames, into: ptr.baseAddress!)
        }
        return buffer
    }

    func testSilentBeforeAnyNote() {
        let core = makeCore()
        let buffer = renderBlock(core, frames: 512)
        XCTAssertTrue(buffer.allSatisfy { $0 == 0 })
    }

    func testHeldNoteProducesBoundedFiniteAudio() {
        let core = makeCore()
        core.noteOn(id: 1, frequency: 440)

        let buffer = renderBlock(core, frames: 8192)
        XCTAssertTrue(buffer.allSatisfy { $0.isFinite && abs($0) <= 1.0 })
        XCTAssertTrue(buffer.contains { abs($0) > 0.01 })
    }

    /// Mirrors the source's `monoNoteOn`/`monoNoteOff` last-note-priority behavior:
    /// releasing the top of a two-note stack should re-attack the note underneath it,
    /// not go silent.
    func testMonophonicLastNotePriorityFallsBackToPreviousHeldNote() {
        let core = makeCore()
        core.portamentoOn = false
        core.attackSeconds = 0.001
        core.decaySeconds = 0.001

        core.noteOn(id: 1, frequency: 220)
        _ = renderBlock(core, frames: 2048) // let the first note settle

        core.noteOn(id: 2, frequency: 440)
        _ = renderBlock(core, frames: 2048)

        core.noteOff(id: 2)
        let afterFallback = renderBlock(core, frames: 4096)

        XCTAssertTrue(afterFallback.allSatisfy { $0.isFinite })
        XCTAssertTrue(afterFallback.contains { abs($0) > 0.001 }, "falling back to note 1 should still sound, not go silent")
    }

    func testReleasingLastNoteEventuallyReachesSilence() {
        let core = makeCore()
        core.releaseSeconds = 0.01

        core.noteOn(id: 1, frequency: 220)
        _ = renderBlock(core, frames: 4096)
        core.noteOff(id: 1)

        // past the release tail, output should have decayed to (near) silence
        _ = renderBlock(core, frames: 4096)
        let tail = renderBlock(core, frames: 4096)
        XCTAssertTrue(tail.allSatisfy { abs($0) < 0.01 })
    }
}
