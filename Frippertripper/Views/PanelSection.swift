import SwiftUI

/// Reports a `PanelSection`'s natural height up to an ancestor via `.onPreferenceChange`,
/// so a group of panels can measure each other and match the tallest - see `matchedHeight`.
struct PanelHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

/// Lightweight stand-in for the source's `Panel.vue` framed-unit chrome. Visual
/// polish (metal texture, rivets) is deferred to Phase 6 - this establishes the
/// grouping/labeling structure the front panel needs now.
struct PanelSection<Content: View>: View {
    let title: String
    /// When set, the panel grows to this height instead of its own natural content
    /// height - lets a row of visually mismatched panels (e.g. knobs next to tall
    /// sliders) share one uniform size. Typically fed by a `PanelHeightPreferenceKey`
    /// reading from the same group of panels, so they end up matching the tallest.
    var matchedHeight: CGFloat? = nil
    @ViewBuilder var content: Content

    @Environment(\.panelControlScale) private var controlScale

    var body: some View {
        VStack(alignment: .leading, spacing: 12 * controlScale) {
            Text(title.uppercased())
                .font(.system(size: 11 * controlScale, weight: .bold))
                .foregroundStyle(.secondary)
                .tracking(1.2)
            content
        }
        .padding(14 * controlScale)
        .frame(maxWidth: .infinity, minHeight: matchedHeight, alignment: .topLeading)
        .background(Color(white: 0.09))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(white: 0.2), lineWidth: 1)
        )
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: PanelHeightPreferenceKey.self, value: geo.size.height)
            }
        )
    }
}
