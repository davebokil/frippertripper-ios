import XCTest
import Accelerate
@testable import Frippertripper

final class OscillatorTests: XCTestCase {
    private let sampleRate: Double = 44100

    private func fixedRender(
        _ osc: Oscillator,
        frequency: Float,
        pulseWidth: Float = 0.5,
        mixSaw: Float = 0,
        mixPulse: Float = 0,
        mixSub: Float = 0,
        mixNoise: Float = 0,
        count: Int
    ) -> [Float] {
        (0..<count).map { _ in
            osc.render(
                frequency: frequency,
                pulseWidth: pulseWidth,
                mixSawLevel: mixSaw,
                mixPulseLevel: mixPulse,
                mixSubLevel: mixSub,
                mixNoiseLevel: mixNoise,
                pwmEnvIn: 0,
                lfoRate: 5,
                lfoDepth: 0,
                pwmSource: .manual,
                subMode: .minus1Square,
                lfoWaveform: .triangle,
                lfoToPitchOn: false
            ).audio
        }
    }

    func testOutputIsFiniteAndBoundedAcrossFrequencySweep() {
        for frequency: Float in [20, 55, 220, 440, 1760, 8000, 15000] {
            let osc = Oscillator()
            osc.prepare(sampleRate: sampleRate)
            let samples = fixedRender(osc, frequency: frequency, mixSaw: 0.25, mixPulse: 0.25, mixSub: 0.25, mixNoise: 0.25, count: 2048)
            XCTAssertTrue(samples.allSatisfy { $0.isFinite }, "frequency \(frequency)Hz produced non-finite output")
            XCTAssertTrue(samples.allSatisfy { abs($0) <= 1.0 }, "frequency \(frequency)Hz exceeded unity bound")
        }
    }

    func testSubOscToggleSignAcrossMainCycles() {
        let osc = Oscillator()
        osc.prepare(sampleRate: sampleRate)
        // Low frequency so several full VCO cycles fit in a short buffer.
        let samples = fixedRender(osc, frequency: 100, mixSub: 1, count: 4410)
        let hasPositive = samples.contains { $0 > 0.1 }
        let hasNegative = samples.contains { $0 < -0.1 }
        XCTAssertTrue(hasPositive && hasNegative, "-1sq sub-oscillator should toggle sign across VCO cycles")
    }

    /// PolyBLEP band-limiting should measurably reduce energy concentrated near Nyquist
    /// (where a naive, non-corrected sawtooth's hard discontinuity dumps aliased energy)
    /// compared to a hand-rolled naive sawtooth at the same frequency.
    func testPolyBlepReducesHighFrequencyEnergyVersusNaiveSawtooth() {
        let frequency: Float = 4000
        let count = 4096

        let osc = Oscillator()
        osc.prepare(sampleRate: sampleRate)
        let bandLimited = fixedRender(osc, frequency: frequency, mixSaw: 1, count: count)

        var phase = 0.0
        let dt = Double(frequency) / sampleRate
        var naive = [Float](repeating: 0, count: count)
        for i in 0..<count {
            naive[i] = Float(2 * phase - 1)
            phase += dt
            if phase >= 1 { phase -= 1 }
        }

        let highBandCutoff = sampleRate / 4 // Nyquist/2
        let bandLimitedFraction = highFrequencyEnergyFraction(bandLimited, sampleRate: sampleRate, cutoffHz: highBandCutoff)
        let naiveFraction = highFrequencyEnergyFraction(naive, sampleRate: sampleRate, cutoffHz: highBandCutoff)

        XCTAssertLessThan(
            bandLimitedFraction, naiveFraction,
            "PolyBLEP-corrected saw should have less high-frequency energy than the naive, non-band-limited saw"
        )
    }
}

/// Fraction of total FFT magnitude energy at or above `cutoffHz`. `signal.count` must
/// be a power of two.
private func highFrequencyEnergyFraction(_ signal: [Float], sampleRate: Double, cutoffHz: Double) -> Float {
    let n = signal.count
    let log2n = vDSP_Length(log2(Double(n)))
    guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else { return 0 }
    defer { vDSP_destroy_fftsetup(fftSetup) }

    var real = signal
    var imaginary = [Float](repeating: 0, count: n)
    var magnitudes = [Float](repeating: 0, count: n / 2)

    real.withUnsafeMutableBufferPointer { realPtr in
        imaginary.withUnsafeMutableBufferPointer { imagPtr in
            var splitComplex = DSPSplitComplex(realp: realPtr.baseAddress!, imagp: imagPtr.baseAddress!)
            vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))
            vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(n / 2))
        }
    }

    let binHz = sampleRate / Double(n)
    let cutoffBin = min(Int(cutoffHz / binHz), magnitudes.count - 1)
    let total = magnitudes.reduce(0, +)
    guard total > 0 else { return 0 }
    let highEnergy = magnitudes[cutoffBin...].reduce(0, +)
    return highEnergy / total
}
