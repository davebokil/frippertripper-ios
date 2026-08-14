import SwiftUI

struct EnvelopePanelView: View {
    @Bindable var engine: SynthEngine
    var matchedHeight: CGFloat? = nil

    var body: some View {
        PanelSection(title: "Envelope", matchedHeight: matchedHeight) {
            HStack(spacing: 18) {
                KnobView(label: "Attack", value: $engine.attack, range: 0.001...3, scale: .logarithmic, formatter: secondsLabel)
                KnobView(label: "Decay", value: $engine.decay, range: 0.001...3, scale: .logarithmic, formatter: secondsLabel)
                KnobView(label: "Sustain", value: $engine.sustain, range: 0...1, formatter: { String(format: "%.0f%%", $0 * 100) })
                KnobView(label: "Release", value: $engine.release, range: 0.001...5, scale: .logarithmic, formatter: secondsLabel)
            }
        }
    }

    private func secondsLabel(_ value: Float) -> String {
        value < 1 ? String(format: "%.0fms", value * 1000) : String(format: "%.2fs", value)
    }
}
