import SwiftUI

/// Momentary/toggle button - matches the source's `PanelButton.vue` (used for
/// Hold and Random).
struct PanelButtonView: View {
    let label: String
    var isOn: Bool = false
    let action: () -> Void

    @Environment(\.panelControlScale) private var controlScale

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11 * controlScale, weight: .semibold))
                .padding(.horizontal, 12 * controlScale)
                .frame(minWidth: 64 * controlScale, minHeight: 36 * controlScale)
                .background(isOn ? Color.brandOrange.opacity(0.75) : Color(white: 0.16))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
