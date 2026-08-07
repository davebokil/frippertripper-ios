import SwiftUI

struct LfoPanelView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "LFO") {
            HStack(spacing: 18) {
                ToggleSwitchView(label: "Wave", selection: $engine.lfoWaveform, options: [.triangle, .square, .sh, .noise]) {
                    switch $0 {
                    case .triangle: "Tri"
                    case .square: "Sqr"
                    case .sh: "S&H"
                    case .noise: "Noise"
                    }
                }
                KnobView(label: "Rate", value: $engine.lfoRate, range: 0.1...30, scale: .logarithmic, formatter: { String(format: "%.1fHz", $0) })
                KnobView(label: "Depth", value: $engine.lfoDepth, range: 0...1, formatter: { String(format: "%.0f%%", $0 * 100) })
                ToggleSwitchView(label: "To Pitch", selection: $engine.lfoToPitchOn, options: [false, true]) { $0 ? "On" : "Off" }
            }
        }
    }
}
