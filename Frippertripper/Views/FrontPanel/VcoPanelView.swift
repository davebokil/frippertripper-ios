import SwiftUI

struct VcoPanelView: View {
    @Bindable var engine: SynthEngine
    var matchedHeight: CGFloat? = nil

    var body: some View {
        PanelSection(title: "VCO", matchedHeight: matchedHeight) {
            HStack(spacing: 18) {
                KnobSwitchView(label: "Range", selection: $engine.vcoRange, options: [.sixteen, .eight, .four, .two]) {
                    switch $0 {
                    case .sixteen: "16'"
                    case .eight: "8'"
                    case .four: "4'"
                    case .two: "2'"
                    }
                }
                KnobView(label: "Tune", value: $engine.vcoTune, range: -50...50, formatter: { "\(Int($0))¢" })
                KnobView(
                    label: "Pulse Width", value: $engine.vcoPulseWidth, range: 0.02...0.98,
                    formatter: { String(format: "%.0f%%", $0 * 100) }
                )
                ToggleSwitchView(label: "PWM Src", selection: $engine.vcoPwmSource, options: [.manual, .env, .lfo]) {
                    switch $0 {
                    case .manual: "Man"
                    case .env: "Env"
                    case .lfo: "LFO"
                    }
                }
            }
        }
    }
}
