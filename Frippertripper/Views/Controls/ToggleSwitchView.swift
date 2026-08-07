import SwiftUI

/// Tap-to-cycle discrete selector. The source's `ToggleSwitch.vue` uses a drag
/// gesture even for 2-3 option switches; tap-to-cycle is more touch-idiomatic for
/// that small a set of discrete options, so this intentionally doesn't port the drag
/// mechanic (per the plan's UI recommendation).
struct ToggleSwitchView<Option: Equatable>: View {
    let label: String
    @Binding var selection: Option
    let options: [Option]
    let optionLabel: (Option) -> String

    var body: some View {
        Button {
            let index = options.firstIndex(of: selection) ?? 0
            selection = options[(index + 1) % options.count]
        } label: {
            VStack(spacing: 4) {
                Text(optionLabel(selection))
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .frame(minWidth: 48, minHeight: 32)
                    .background(Color(white: 0.16))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Text(label)
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement()
        .accessibilityLabel(label)
        .accessibilityValue(optionLabel(selection))
        .accessibilityHint("Double tap to cycle")
    }
}
