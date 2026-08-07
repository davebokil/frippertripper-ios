import SwiftUI

/// Spring-return pitch/filter bender lever, -1...1. Ports the source's track-fraction
/// drag math (`BenderLever.vue`) but uses SwiftUI's native spring animation for the
/// return-to-center instead of a hand-rolled `requestAnimationFrame` decay loop, per
/// the plan's recommendation.
struct BenderLeverView: View {
    @Binding var position: Float

    private let knobDiameter: CGFloat = 32

    var body: some View {
        GeometryReader { geo in
            let usableHeight = geo.size.height - knobDiameter
            let knobY = geo.size.height / 2 - CGFloat(position) * (usableHeight / 2)

            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(white: 0.1))
                    .frame(width: 12)

                Circle()
                    .fill(Color.orange)
                    .overlay(Circle().stroke(Color(white: 0.9).opacity(0.4), lineWidth: 1))
                    .frame(width: knobDiameter, height: knobDiameter)
                    .position(x: geo.size.width / 2, y: knobY)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        let center = geo.size.height / 2
                        let fraction = Float((center - drag.location.y) / (usableHeight / 2))
                        position = min(max(fraction, -1), 1)
                    }
                    .onEnded { _ in
                        withAnimation(.interpolatingSpring(stiffness: 260, damping: 14)) {
                            position = 0
                        }
                    }
            )
        }
        .accessibilityElement()
        .accessibilityLabel("Pitch/filter bender")
        .accessibilityValue(String(format: "%.2f", position))
    }
}
