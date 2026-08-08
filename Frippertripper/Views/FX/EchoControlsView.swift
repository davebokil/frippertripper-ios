import SwiftUI
import Foundation

struct EchoControlsView: View {
    @Bindable var engine: SynthEngine

    var body: some View {
        PanelSection(title: "Echo") {
            HStack(spacing: 24) {
                HStack(alignment: .center, spacing: 6) {
                    SliderView(label: "Repeat", value: $engine.echoRepeat, range: 0...1)
                        .frame(height: 120)
                    Text(repeatCountLabel(engine.echoRepeat))
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Color.brandOrange)
                        .frame(minWidth: 24, alignment: .leading)
                }
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

    /// Approximate number of audible repeats (until the tail decays below -24dB) for
    /// the current Repeat slider position, mapped through the same
    /// `feedbackFromSlider` curve the engine itself uses - shown as "∞" at the very
    /// top of the slider, where feedback is close enough to unity that repeats
    /// effectively never stop decaying to silence within a normal listening window.
    private func repeatCountLabel(_ value: Float) -> String {
        if value >= 0.999 { return "∞" }
        let feedback = SynthEngineCore.feedbackFromSlider(value)
        guard feedback > 0.0001 else { return "0" }
        let repeats = log(0.063) / log(Double(feedback))
        return "\(max(Int(repeats.rounded()), 0))"
    }
}
