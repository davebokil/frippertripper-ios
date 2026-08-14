import SwiftUI

struct VcaPanelView: View {
    @Bindable var engine: SynthEngine
    var matchedHeight: CGFloat? = nil

    var body: some View {
        PanelSection(title: "VCA", matchedHeight: matchedHeight) {
            ToggleSwitchView(label: "Mode", selection: $engine.vcaMode, options: [.env, .gate]) {
                $0 == .env ? "Env" : "Gate"
            }
        }
    }
}
