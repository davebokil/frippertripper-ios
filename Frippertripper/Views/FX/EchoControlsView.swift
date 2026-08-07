import SwiftUI

struct EchoControlsView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "Echo") {
            HStack(spacing: 24) {
                SliderView(label: "Repeat", value: $engine.echoRepeat, range: 0...1)
                    .frame(height: 120)
                KnobView(label: "Time", value: $engine.echoTime, range: 0...4, formatter: { String(format: "%.2fs", $0) })
                VStack {
                    SliderView(label: "Volume", value: $engine.echoVolume, range: 0...1, orientation: .horizontal)
                        .frame(height: 26)
                    Spacer()
                }
                .frame(height: 120)
            }
        }
    }
}
