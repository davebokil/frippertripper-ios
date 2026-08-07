import Foundation

/// Octave-switch positions on the VCO, mirroring the source app's `VcoRange`
/// (`app/composables/useAudioEngine.ts`). Raw values are the octave offset used by
/// `computeVcoFrequency`, matching `RANGE_OCTAVE`.
enum VcoRange: Equatable {
    case sixteen, eight, four, two

    var octaveOffset: Float {
        switch self {
        case .sixteen: -1
        case .eight: 0
        case .four: 1
        case .two: 2
        }
    }
}

enum PwmSource: Equatable {
    case manual, env, lfo
}

enum SubMode: Equatable {
    case minus1Square, minus2Square, minus2Pulse
}

enum VcaMode: Equatable {
    case env, gate
}

enum LfoWaveform: Equatable {
    case triangle, square, sh, noise
}
