import SwiftUI

/// Combined echo + limiter sheet, opened from the side FX button. A single scrollable
/// sheet rather than tabs - only 6 controls total, so tab navigation would be
/// overhead for no benefit (per the plan).
struct FxPanelView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                EchoControlsView(engine: engine)
                LimiterControlsView(engine: engine)
            }
            .padding(16)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
