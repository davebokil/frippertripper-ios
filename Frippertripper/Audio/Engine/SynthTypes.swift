import Foundation

/// Octave-switch positions on the VCO, mirroring the source app's `VcoRange`
/// (`app/composables/useAudioEngine.ts`). Raw values are the octave offset used by
/// `computeVcoFrequency`, matching `RANGE_OCTAVE`. String-raw-valued (rather than a
/// plain enum) so it round-trips through `SynthPreset`'s JSON encoding.
enum VcoRange: String, Codable, Equatable {
    case sixteen = "16", eight = "8", four = "4", two = "2"

    var octaveOffset: Float {
        switch self {
        case .sixteen: -1
        case .eight: 0
        case .four: 1
        case .two: 2
        }
    }
}

enum PwmSource: String, Codable, Equatable {
    case manual, env, lfo
}

enum SubMode: String, Codable, Equatable {
    case minus1Square, minus2Square, minus2Pulse
}

enum VcaMode: String, Codable, Equatable {
    case env, gate
}

enum LfoWaveform: String, Codable, Equatable {
    case triangle, square, sh, noise
}

enum ArpMode: String, Codable, Equatable {
    case off, down, updown, up
}
