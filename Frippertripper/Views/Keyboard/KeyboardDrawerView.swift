import SwiftUI

/// Non-modal slide-up drawer for the piano keyboard - intentionally not a `.sheet`,
/// since a modal sheet would block interacting with the front-panel controls above
/// it, and holding a note while sweeping a knob with the other hand is core to how
/// this instrument gets played (per the plan).
struct KeyboardDrawerView: View {
    @Bindable var engine: SynthEngine
    @Binding var isPresented: Bool

    @State private var octaveOffset = 0
    @State private var octaveSpan = 2 // how many octaves are visible at once - fewer = wider keys
    @State private var isHoldMode = false

    private let octaveRange = -3...3
    private let spanRange = 1...3

    var body: some View {
        VStack(spacing: 6) {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            octaveRow
            keySizeRow

            PianoKeyboardView(engine: engine, octaveOffset: octaveOffset, octaveSpan: octaveSpan, isHoldMode: isHoldMode)
                .frame(height: 150)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 16)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { drag in
                    if drag.translation.height > 40 {
                        withAnimation { isPresented = false }
                    }
                }
        )
    }

    private var octaveRow: some View {
        HStack(spacing: 12) {
            stepper(
                label: octaveLabel, minWidth: 64,
                decrement: { octaveOffset = max(octaveOffset - 1, octaveRange.lowerBound) },
                increment: { octaveOffset = min(octaveOffset + 1, octaveRange.upperBound) },
                canDecrement: octaveOffset > octaveRange.lowerBound,
                canIncrement: octaveOffset < octaveRange.upperBound
            )

            Spacer()

            PanelButtonView(label: "Hold", isOn: isHoldMode) {
                isHoldMode.toggle()
            }
        }
        .padding(.horizontal, 16)
    }

    private var keySizeRow: some View {
        HStack(spacing: 12) {
            Text("Key Size")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            Spacer()

            stepper(
                label: "\(octaveSpan) oct", minWidth: 44,
                decrement: { octaveSpan = max(octaveSpan - 1, spanRange.lowerBound) },
                increment: { octaveSpan = min(octaveSpan + 1, spanRange.upperBound) },
                canDecrement: octaveSpan > spanRange.lowerBound,
                canIncrement: octaveSpan < spanRange.upperBound
            )
        }
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func stepper(
        label: String, minWidth: CGFloat,
        decrement: @escaping () -> Void, increment: @escaping () -> Void,
        canDecrement: Bool, canIncrement: Bool
    ) -> some View {
        HStack(spacing: 10) {
            Button(action: decrement) {
                Image(systemName: "minus")
                    .frame(width: 30, height: 30)
                    .background(Color(white: 0.18))
                    .clipShape(Circle())
            }
            .disabled(!canDecrement)

            Text(label)
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .frame(minWidth: minWidth)

            Button(action: increment) {
                Image(systemName: "plus")
                    .frame(width: 30, height: 30)
                    .background(Color(white: 0.18))
                    .clipShape(Circle())
            }
            .disabled(!canIncrement)
        }
        .foregroundStyle(.white)
    }

    private var octaveLabel: String {
        let lowMidi = 60 + octaveOffset * 12
        let highMidi = lowMidi + octaveSpan * 12
        let lowName = makePianoNoteRange(lowMidi: lowMidi, highMidi: lowMidi).first?.name ?? ""
        let highName = makePianoNoteRange(lowMidi: highMidi, highMidi: highMidi).first?.name ?? ""
        return "\(lowName)–\(highName)"
    }
}
