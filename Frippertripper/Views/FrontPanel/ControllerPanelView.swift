import SwiftUI

struct ControllerPanelView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "Controller") {
            HStack(spacing: 16) {
                KnobView(label: "Bend VCO", value: $engine.benderVcoSens, range: 0...12, formatter: { String(format: "%.0fst", $0) })
                KnobView(label: "Bend VCF", value: $engine.benderVcfSens, range: 0...4, formatter: { String(format: "%.1foct", $0) })
                KnobView(
                    label: "Porta", value: $engine.portamentoTime, range: 0.001...5, scale: .logarithmic,
                    formatter: { $0 < 1 ? String(format: "%.0fms", $0 * 1000) : String(format: "%.2fs", $0) }
                )
                ToggleSwitchView(label: "Porta", selection: $engine.portamentoOn, options: [false, true]) { $0 ? "On" : "Off" }
                BenderLeverView(position: $engine.benderPosition)
                    .frame(width: 44, height: 90)
            }
        }
    }
}
