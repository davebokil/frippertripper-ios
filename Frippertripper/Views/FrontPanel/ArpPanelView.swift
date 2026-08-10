import SwiftUI

struct ArpPanelView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "Arpeggiator") {
            HStack(alignment: .top, spacing: 18) {
                ToggleSwitchView(label: "Mode", selection: $engine.arpMode, options: [.off, .up, .down, .updown]) {
                    switch $0 {
                    case .off: "Off"
                    case .up: "Up"
                    case .down: "Dn"
                    case .updown: "Up/Dn"
                    }
                }
                KnobView(label: "Rate", value: $engine.arpRate, range: 0.1...20, scale: .logarithmic, formatter: { String(format: "%.1fHz", $0) })
                ToggleSwitchView(label: "Octaves", selection: $engine.arpOctaves, options: [1, 2, 3]) { "\($0)" }
                PanelButtonView(label: "Hold", isOn: engine.arpHold) { engine.arpHold.toggle() }
            }
        }
    }
}
