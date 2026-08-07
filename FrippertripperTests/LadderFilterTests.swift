import XCTest
@testable import Frippertripper

final class LadderFilterTests: XCTestCase {
    private let sampleRate: Double = 44100

    /// The source's own implementation comment claims numerical stability across the
    /// full audio range, including right at the self-oscillation edge (resonance ~= 1).
    /// This sweeps that range and asserts no NaN/Inf/blow-up, at the maximum resonance
    /// the UI can produce (resonance knob = 1.0 -> resonanceGain = RESONANCE_MAX = 4.0,
    /// which is where the ladder self-oscillates).
    func testStableAcrossFullCutoffRangeAtMaxResonance() {
        let cutoffs: [Float] = [20, 55, 110, 220, 440, 880, 1760, 3520, 7040, 14000, 18000]

        for cutoff in cutoffs {
            let filter = LadderFilter()
            filter.prepare(sampleRate: sampleRate)

            var maxAbs: Float = 0
            // Excite the filter with an impulse then let it ring - this is exactly the
            // self-oscillation scenario the source comment calls out as verified.
            for i in 0..<8192 {
                let input: Float = i == 0 ? 1 : 0
                let output = filter.process(
                    input: input,
                    cutoffBase: cutoff,
                    resonance: 1.0,
                    envAmount: 0,
                    envIn: 0,
                    lfoDepth: 0,
                    lfoIn: 0,
                    filterLfoOn: false
                )
                XCTAssertTrue(output.isFinite, "cutoff \(cutoff)Hz produced non-finite output at sample \(i)")
                maxAbs = max(maxAbs, abs(output))
            }
            XCTAssertLessThan(maxAbs, 10, "cutoff \(cutoff)Hz output grew unreasonably large (possible instability)")
        }
    }

    func testLowpassAttenuatesAboveCutoff() {
        let filter = LadderFilter()
        filter.prepare(sampleRate: sampleRate)

        let cutoff: Float = 500
        let toneFrequency: Double = 8000 // well above cutoff
        var phase = 0.0
        let dt = toneFrequency / sampleRate

        var inputEnergy: Float = 0
        var outputEnergy: Float = 0

        // Run past the filter's transient before measuring energy.
        for i in 0..<8192 {
            let input = Float(sin(phase * 2 * .pi))
            let output = filter.process(
                input: input, cutoffBase: cutoff, resonance: 0, envAmount: 0, envIn: 0,
                lfoDepth: 0, lfoIn: 0, filterLfoOn: false
            )
            if i >= 4096 {
                inputEnergy += input * input
                outputEnergy += output * output
            }
            phase += dt
            if phase >= 1 { phase -= 1 }
        }

        XCTAssertLessThan(outputEnergy, inputEnergy * 0.1, "a tone well above cutoff should be strongly attenuated")
    }
}
