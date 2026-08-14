import SwiftUI

struct FilterPanelView: View {
    @Bindable var engine: SynthEngine
    var matchedHeight: CGFloat? = nil

    var body: some View {
        PanelSection(title: "Filter", matchedHeight: matchedHeight) {
            HStack(spacing: 18) {
                KnobView(
                    label: "Cutoff", value: $engine.filterCutoff, range: 20...20000, scale: .logarithmic,
                    formatter: { $0 >= 1000 ? String(format: "%.1fk", $0 / 1000) : String(format: "%.0f", $0) }
                )
                KnobView(label: "Res", value: $engine.filterResonance, range: 0...1, formatter: { String(format: "%.0f%%", $0 * 100) })
                KnobView(label: "Env Amt", value: $engine.filterEnvAmount, range: -1...1, formatter: { String(format: "%.2f", $0) })
                KnobView(label: "Key Flw", value: $engine.filterKeyFollow, range: 0...1, formatter: { String(format: "%.0f%%", $0 * 100) })
                ToggleSwitchView(label: "LFO", selection: $engine.filterLfoOn, options: [false, true]) { $0 ? "On" : "Off" }
            }
        }
    }
}
