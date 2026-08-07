/// Fast, low-quality-but-adequate PRNG for the noise source and sample-&-hold LFO.
/// The source app uses `mulberry32`; bit-exact parity doesn't matter here since noise
/// is cosmetic, so any decent fast generator suffices.
struct Xorshift32 {
    private var state: UInt32

    init(seed: UInt32) {
        state = seed == 0 ? 0x9E3779B9 : seed
    }

    mutating func next() -> UInt32 {
        state ^= state << 13
        state ^= state >> 17
        state ^= state << 5
        return state
    }

    /// Uniform value in [0, 1).
    mutating func nextUnit() -> Float {
        Float(next()) / Float(UInt32.max)
    }
}
