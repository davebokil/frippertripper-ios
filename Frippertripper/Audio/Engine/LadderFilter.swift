import Foundation

/// Port of `public/worklets/sh101-filter-processor.js`: a 4-pole (24dB/oct)
/// self-oscillating lowpass ladder filter, TPT (topology-preserving transform)
/// one-pole cascade with one-sample-delayed `tanh`-soft-clipped feedback. This
/// specific topology avoids solving an implicit zero-delay-feedback loop per sample
/// while remaining numerically stable across the full audio range, including at
/// self-oscillation (resonance ~= 1) — verified by the source's own test sweep, which
/// `LadderFilterTests` reproduces natively.
final class LadderFilter: @unchecked Sendable {
    private var z1: Double = 0
    private var z2: Double = 0
    private var z3: Double = 0
    private var z4: Double = 0
    private var prevY4: Double = 0
    private var sampleRate: Double = 44100

    static let resonanceMax: Float = 4.0
    static let envToCutoffOctaves: Float = 6
    static let lfoToCutoffOctaves: Float = 3

    func prepare(sampleRate: Double) {
        self.sampleRate = sampleRate
        z1 = 0; z2 = 0; z3 = 0; z4 = 0
        prevY4 = 0
    }

    func process(
        input: Float,
        cutoffBase: Float,
        resonance: Float,
        envAmount: Float,
        envIn: Float,
        lfoDepth: Float,
        lfoIn: Float,
        filterLfoOn: Bool
    ) -> Float {
        let envOctaves = envAmount * envIn * Self.envToCutoffOctaves
        let lfoOctaves: Float = filterLfoOn ? lfoIn * lfoDepth * Self.lfoToCutoffOctaves : 0
        let effectiveCutoff = min(
            max(cutoffBase * pow(2, envOctaves + lfoOctaves), 20),
            Float(sampleRate * 0.48)
        )

        let g = tan(Double.pi * Double(effectiveCutoff) / sampleRate)
        let G = g / (1 + g)
        let resonanceGain = Double(resonance * Self.resonanceMax)

        let x1 = Double(input) - resonanceGain * tanh(prevY4)

        let v1 = G * (x1 - z1); let y1 = v1 + z1; z1 = y1 + v1
        let v2 = G * (y1 - z2); let y2 = v2 + z2; z2 = y2 + v2
        let v3 = G * (y2 - z3); let y3 = v3 + z3; z3 = y3 + v3
        let v4 = G * (y3 - z4); let y4 = v4 + z4; z4 = y4 + v4

        prevY4 = y4
        return Float(y4)
    }
}
