import Foundation

/// Shared linear/log value<->fraction mapping used by Knob and Slider, matching the
/// source's `Knob.vue`/`Slider.vue` `toFraction`/`fromFraction` helpers.
enum ControlScale {
    case linear
    case logarithmic

    func toFraction(_ value: Float, range: ClosedRange<Float>) -> Float {
        switch self {
        case .linear:
            return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        case .logarithmic:
            let lo = log(max(range.lowerBound, .leastNormalMagnitude))
            let hi = log(range.upperBound)
            return (log(max(value, .leastNormalMagnitude)) - lo) / (hi - lo)
        }
    }

    func fromFraction(_ fraction: Float, range: ClosedRange<Float>) -> Float {
        let clamped = min(max(fraction, 0), 1)
        switch self {
        case .linear:
            return range.lowerBound + clamped * (range.upperBound - range.lowerBound)
        case .logarithmic:
            let lo = log(max(range.lowerBound, .leastNormalMagnitude))
            let hi = log(range.upperBound)
            return exp(lo + clamped * (hi - lo))
        }
    }
}
