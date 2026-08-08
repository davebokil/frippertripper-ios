import SwiftUI

/// White keys equal-width, black keys positioned at
/// `(precedingWhiteIndex+1)*whiteWidth - blackWidth/2` with a 0.65 width ratio -
/// ports the source's `PianoKeyboard.vue` layout math directly. `octaveOffset` shifts
/// the visible/playable MIDI range up or down in whole octaves; `octaveSpan` controls
/// how many octaves are visible at once (fewer octaves -> each key gets proportionally
/// wider, since key width is the available width divided by key count) - lets players
/// with bigger hands trade range-per-screen for bigger touch targets.
///
/// Unlike the source (independent Pointer Events per `<div>` key), this uses one
/// gesture spanning the whole keyboard region that hit-tests which key rect contains
/// the current touch point each frame - SwiftUI per-key `Button` taps don't support
/// sliding a finger across keys (glissando), which a single spanning gesture does
/// naturally (per the plan's recommendation).
///
/// `isHoldMode` switches the interaction model: off (default) is press-and-hold
/// (release to stop, as normal); on is tap-to-latch (tap a key to sustain it
/// hands-free, tap it again to release) - lets both hands stay on the front-panel
/// knobs while a note rings out, without needing a finger anchored on the keyboard.
///
/// Hold latches a *set* of notes, not just one: which of them you actually hear
/// depends on `SynthEngineCore`, same as normal play - this is a monophonic engine
/// (one voice, like the source's SH-101-style design), so with arp off, the most
/// recently latched note sounds and releasing it falls back to the next one still
/// latched (last-note-priority). With an arp mode active, all latched notes become
/// the arp's chord pool and it steps through them - that's the way to sound more than
/// one note "at once" on this instrument.
struct PianoKeyboardView: View {
    @Bindable var engine: SynthEngine
    var octaveOffset: Int
    var octaveSpan: Int = 2
    var isHoldMode: Bool

    private let blackKeyWidthRatio: CGFloat = 0.65

    @State private var dragNoteId: Int?
    @State private var latchedNoteIds: Set<Int> = []

    private var notes: [PianoNote] {
        let span = max(octaveSpan, 1)
        let low = max(0, min(60 + octaveOffset * 12, 127 - span * 12))
        return makePianoNoteRange(lowMidi: low, highMidi: low + span * 12)
    }
    private var whiteNotes: [PianoNote] { notes.filter { !$0.isSharp } }
    private var blackNotes: [PianoNote] { notes.filter { $0.isSharp } }

    // Flat top (flush with the keyboard's upper edge and with neighboring keys),
    // rounded bottom (the exposed edge) - matches the rounded-corner language used
    // everywhere else in the app rather than the piano's sharp 90-degree rectangles.
    private var whiteKeyShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 6, bottomTrailingRadius: 6, topTrailingRadius: 0)
    }
    private var blackKeyShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 4, bottomTrailingRadius: 4, topTrailingRadius: 0)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0 / 30.0)) { _ in
            GeometryReader { geo in
                let whiteWidth = geo.size.width / CGFloat(whiteNotes.count)
                let blackWidth = whiteWidth * blackKeyWidthRatio
                let soundingId = engine.core.currentNoteId

                ZStack(alignment: .topLeading) {
                    HStack(spacing: 0) {
                        ForEach(whiteNotes) { note in
                            whiteKeyShape
                                .fill(whiteKeyColor(note: note, soundingId: soundingId))
                                .overlay(whiteKeyShape.stroke(Color.black.opacity(0.25), lineWidth: 0.5))
                        }
                    }

                    ForEach(blackNotes) { note in
                        let xOffset = blackKeyXOffset(for: note, whiteWidth: whiteWidth, blackWidth: blackWidth)
                        blackKeyShape
                            .fill(blackKeyColor(note: note, soundingId: soundingId))
                            .frame(width: blackWidth, height: geo.size.height * 0.62)
                            .position(x: xOffset + blackWidth / 2, y: geo.size.height * 0.31)
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            guard let note = hitTest(
                                point: drag.location, whiteWidth: whiteWidth, blackWidth: blackWidth, height: geo.size.height
                            ) else { return }

                            if isHoldMode {
                                guard dragNoteId != note.id else { return } // only act once per touch-down
                                dragNoteId = note.id
                                if latchedNoteIds.contains(note.id) {
                                    engine.noteOff(id: note.id)
                                    latchedNoteIds.remove(note.id)
                                } else {
                                    engine.noteOn(id: note.id, frequency: note.frequency)
                                    latchedNoteIds.insert(note.id)
                                }
                            } else if note.id != dragNoteId {
                                if let previous = dragNoteId { engine.noteOff(id: previous) }
                                dragNoteId = note.id
                                engine.noteOn(id: note.id, frequency: note.frequency)
                            }
                        }
                        .onEnded { _ in
                            if isHoldMode {
                                dragNoteId = nil // ready for the next fresh touch-down; latched notes keep sounding
                            } else if let id = dragNoteId {
                                engine.noteOff(id: id)
                                dragNoteId = nil
                            }
                        }
                )
            }
        }
        .onChange(of: isHoldMode) { _, holding in
            if !holding {
                for id in latchedNoteIds { engine.noteOff(id: id) }
                latchedNoteIds.removeAll()
            }
        }
        .onChange(of: octaveOffset) { _, _ in resetHeldNotes() }
        .onChange(of: octaveSpan) { _, _ in resetHeldNotes() }
    }

    private func resetHeldNotes() {
        for id in latchedNoteIds { engine.noteOff(id: id) }
        latchedNoteIds.removeAll()
        if let id = dragNoteId { engine.noteOff(id: id) }
        dragNoteId = nil
    }

    private func whiteKeyColor(note: PianoNote, soundingId: Int) -> Color {
        if soundingId == note.id { return .brandOrange.opacity(0.55) }
        if latchedNoteIds.contains(note.id) { return Self.latchedKeyColor }
        return .brandOrange
    }

    private func blackKeyColor(note: PianoNote, soundingId: Int) -> Color {
        if soundingId == note.id { return Self.soundingBlackKeyColor }
        if latchedNoteIds.contains(note.id) { return Self.latchedKeyColor }
        return .black
    }

    /// Latched-but-not-currently-sounding keys (Hold mode) get this same solid grey
    /// on both key colors, so "held" reads as one consistent state regardless of
    /// which key it's on - distinct from black's idle color and from the bright
    /// orange "currently sounding" color on either key.
    private static let latchedKeyColor = Color(white: 0.35)

    /// A black key sits on top of the (now orange, since it matches the app icon)
    /// white keys in the ZStack, so a translucent orange fill here would blend with
    /// that orange backdrop and resolve right back to plain orange - invisible as a
    /// distinct "sounding" state. This is `brandOrange` pre-blended at 40% over
    /// black as an opaque color instead, so it reads correctly regardless of what's
    /// underneath.
    private static let soundingBlackKeyColor = Color(red: 0.4, green: 0.4 * 130 / 255, blue: 0.4 * 20 / 255)

    private func blackKeyXOffset(for note: PianoNote, whiteWidth: CGFloat, blackWidth: CGFloat) -> CGFloat {
        let precedingWhiteIndex = whiteNotes.lastIndex { $0.id < note.id } ?? 0
        return CGFloat(precedingWhiteIndex + 1) * whiteWidth - blackWidth / 2
    }

    private func hitTest(point: CGPoint, whiteWidth: CGFloat, blackWidth: CGFloat, height: CGFloat) -> PianoNote? {
        if point.y < height * 0.62 {
            for note in blackNotes {
                let xOffset = blackKeyXOffset(for: note, whiteWidth: whiteWidth, blackWidth: blackWidth)
                if point.x >= xOffset, point.x <= xOffset + blackWidth {
                    return note
                }
            }
        }
        let whiteIndex = Int(point.x / whiteWidth)
        guard whiteIndex >= 0, whiteIndex < whiteNotes.count else { return nil }
        return whiteNotes[whiteIndex]
    }
}
