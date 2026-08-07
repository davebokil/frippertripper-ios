import SwiftUI

/// Segmented LED-style gain-reduction meter, polling `SynthEngineCore.limiterReductionDb`
/// at ~30Hz via `TimelineView` (matches the source's `requestAnimationFrame` meter
/// loop reading `compressor.reduction`). Reduction is <= 0 dB; segments light from the
/// bottom as reduction increases, green -> amber -> red.
struct GRMeterView: View {
    let core: SynthEngineCore

    private let segmentCount = 10
    private let displayRangeDb: Float = 18 // 0...-18dB spread across the meter

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0 / 30.0)) { _ in
            let reduction = -core.limiterReductionDb // >= 0
            let litFraction = min(reduction / displayRangeDb, 1)
            let litSegments = Int((litFraction * Float(segmentCount)).rounded(.up))

            VStack(spacing: 2) {
                ForEach((0..<segmentCount).reversed(), id: \.self) { index in
                    let isLit = (segmentCount - index) <= litSegments
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(isLit ? color(forSegment: index) : Color(white: 0.14))
                }
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Gain reduction")
        .accessibilityValue(String(format: "%.1f dB", core.limiterReductionDb))
    }

    private func color(forSegment index: Int) -> Color {
        if index < 2 { return .red }
        if index < 4 { return .yellow }
        return .green
    }
}
