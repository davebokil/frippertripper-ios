import XCTest
@testable import Frippertripper

final class ArpeggiatorTests: XCTestCase {
    private func makeCore() -> SynthEngineCore {
        let core = SynthEngineCore()
        core.prepare(sampleRate: 44100)
        core.attackSeconds = 0.001
        core.decaySeconds = 0.001
        core.releaseSeconds = 0.001
        core.setEchoVolume(0) // isolate arp/voice behavior from the (separately-tested) echo tail
        return core
    }

    private func render(_ core: SynthEngineCore, frames: Int) -> [Float] {
        var buffer = [Float](repeating: 0, count: frames)
        buffer.withUnsafeMutableBufferPointer { ptr in
            core.render(frameCount: frames, into: ptr.baseAddress!)
        }
        return buffer
    }

    func testArpModeProducesRepeatingSteppedOutputWhileHeld() {
        let core = makeCore()
        core.arpMode = .up
        core.arpRate = 20 // fast steps for a short test

        core.noteOn(id: 1, frequency: 220)
        core.noteOn(id: 2, frequency: 440)

        var stepChanges = 0
        var lastId = core.currentNoteId
        for _ in 0..<20 {
            _ = render(core, frames: 4410) // 0.1s per block, 2 steps per block at 20Hz
            if core.currentNoteId != lastId {
                stepChanges += 1
                lastId = core.currentNoteId
            }
        }

        XCTAssertGreaterThan(stepChanges, 0, "arp should step between held notes over time")
    }

    func testTurningArpOffStopsSteppingAndSilencesVoice() {
        let core = makeCore()
        core.arpMode = .up
        core.arpRate = 20
        core.noteOn(id: 1, frequency: 220)
        _ = render(core, frames: 8820)

        core.arpMode = .off
        _ = render(core, frames: 4410)
        XCTAssertEqual(core.currentNoteId, -1)

        let silentTail = render(core, frames: 4410)
        XCTAssertTrue(silentTail.allSatisfy { abs($0) < 0.01 })
    }

    func testHoldLatchesNotesAfterRelease() {
        let core = makeCore()
        core.arpMode = .up
        core.arpRate = 20
        core.arpHold = true

        core.noteOn(id: 1, frequency: 220)
        core.noteOff(id: 1) // released, but Hold should latch it

        let buffer = render(core, frames: 8820)
        XCTAssertTrue(buffer.contains { abs($0) > 0.01 }, "held (latched) note should keep arpeggiating after release")
    }
}
