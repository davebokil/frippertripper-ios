import SwiftUI

struct SourceMixerPanelView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "Source Mixer") {
            HStack(spacing: 0) {
                SliderView(label: "Saw", value: $engine.mixSawLevel, range: 0...1)
                    .frame(height: 110)
                Spacer()
                SliderView(label: "Pulse", value: $engine.mixPulseLevel, range: 0...1)
                    .frame(height: 110)
                Spacer()
                SliderView(label: "Sub", value: $engine.mixSubLevel, range: 0...1)
                    .frame(height: 110)
                Spacer()
                SliderView(label: "Noise", value: $engine.mixNoiseLevel, range: 0...1)
                    .frame(height: 110)
                Spacer()
                ToggleSwitchView(
                    label: "Sub Mode", selection: $engine.mixSubMode,
                    options: [.minus1Square, .minus2Square, .minus2Pulse]
                ) {
                    switch $0 {
                    case .minus1Square: "-1sq"
                    case .minus2Square: "-2sq"
                    case .minus2Pulse: "-2pls"
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
