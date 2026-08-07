import SwiftUI

/// Momentary/toggle button - matches the source's `PanelButton.vue` (used for
/// Hold and Random).
struct PanelButtonView: View {
    let label: String
    var isOn: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .frame(minWidth: 64, minHeight: 36)
                .background(isOn ? Color.orange.opacity(0.75) : Color(white: 0.16))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
