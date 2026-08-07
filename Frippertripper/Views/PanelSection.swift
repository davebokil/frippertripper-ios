import SwiftUI

/// Lightweight stand-in for the source's `Panel.vue` framed-unit chrome. Visual
/// polish (metal texture, rivets) is deferred to Phase 6 - this establishes the
/// grouping/labeling structure the front panel needs now.
struct PanelSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.secondary)
                .tracking(1.2)
            content
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(white: 0.09))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(white: 0.2), lineWidth: 1)
        )
    }
}
