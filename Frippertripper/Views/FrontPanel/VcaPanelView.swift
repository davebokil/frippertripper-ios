import SwiftUI

struct VcaPanelView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "VCA") {
            ToggleSwitchView(label: "Mode", selection: $engine.vcaMode, options: [.env, .gate]) {
                $0 == .env ? "Env" : "Gate"
            }
        }
    }
}
