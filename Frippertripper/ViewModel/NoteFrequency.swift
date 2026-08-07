import Foundation

/// Port of `app/composables/useNoteFrequency.ts`: A440 equal temperament, and the
/// 2-octave-plus-top-C range (MIDI 60-84) the on-screen keyboard displays. Note
/// identity is the MIDI note number itself (unlike the source's string ids like
/// "C4"), which the monophonic held-note stack in `SynthEngineCore` uses directly.
struct PianoNote: Identifiable, Equatable {
    let id: Int // MIDI note number
    let name: String
    let isSharp: Bool
    let frequency: Float
}

func midiToFrequency(_ midiNote: Int) -> Float {
    440 * pow(2, Float(midiNote - 69) / 12)
}

func makePianoNoteRange(lowMidi: Int = 60, highMidi: Int = 84) -> [PianoNote] {
    let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    return (lowMidi...highMidi).map { midi in
        let name = names[midi % 12]
        let octave = midi / 12 - 1
        return PianoNote(
            id: midi,
            name: "\(name)\(octave)",
            isSharp: name.contains("#"),
            frequency: midiToFrequency(midi)
        )
    }
}
