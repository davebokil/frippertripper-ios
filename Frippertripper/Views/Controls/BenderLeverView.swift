import SwiftUI

/// Spring-return pitch/filter bender lever, -1...1. Ports the source's track-fraction
/// drag math (`BenderLever.vue`) but uses SwiftUI's native spring animation for the
/// return-to-center instead of a hand-rolled `requestAnimationFrame` decay loop, per
/// the plan's recommendation.
struct BenderLeverView: View {
    @Binding var position: Float

    private let knobDiameter: CGFloat = 36
    private let trackWidth: CGFloat = 18

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                let usableHeight = geo.size.height - knobDiameter
                let knobY = geo.size.height / 2 - CGFloat(position) * (usableHeight / 2)

                ZStack {
                    RoundedRectangle(cornerRadius: trackWidth / 2)
                        .fill(Color(white: 0.28))
                        .frame(width: trackWidth)

                    // Center-rest tick, so the spring-return position reads clearly.
                    Rectangle()
                        .fill(Color(white: 0.55))
                        .frame(width: trackWidth + 10, height: 2)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)

                    Circle()
                        .fill(Color.brandOrange)
                        .overlay(Circle().stroke(Color(white: 0.95).opacity(0.6), lineWidth: 1.5))
                        .shadow(color: .brandOrange.opacity(0.5), radius: 4)
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

            Text("Bend")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .accessibilityElement()
        .accessibilityLabel("Pitch/filter bender")
        .accessibilityValue(String(format: "%.2f", position))
    }
}
