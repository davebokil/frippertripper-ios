import SwiftUI

struct LimiterControlsView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "Limiter") {
            HStack(spacing: 24) {
                KnobView(label: "Threshold", value: $engine.limiterThreshold, range: -24...0, formatter: { String(format: "%.0fdB", $0) })
                KnobView(label: "Ceiling", value: $engine.limiterCeiling, range: -24...0, formatter: { String(format: "%.0fdB", $0) })
                VStack(spacing: 4) {
                    GRMeterView(core: engine.core)
                        .frame(width: 26, height: 100)
                    Text("GR")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
