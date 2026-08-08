import SwiftUI

/// Rotary knob controlled by vertical drag distance, matching the source's
/// `Knob.vue` mechanic (drag-Y, not literal rotation). Sweep distance is widened
/// versus the source's 220px (touch precision is worse than mouse precision).
struct KnobView: View {
    let label: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    var scale: ControlScale = .linear
    var formatter: (Float) -> String = { String(format: "%.2f", $0) }
    var size: CGFloat = 52

    @State private var dragStartValue: Float?

    private let sweepDistance: CGFloat = 300
    private let minAngle: Double = -135
    private let maxAngle: Double = 135

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [Color(white: 0.22), Color(white: 0.12)], startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(Circle().stroke(Color(white: 0.35), lineWidth: 1))
                Capsule()
                    .fill(Color.brandOrange)
                    .frame(width: 3, height: size * 0.32)
                    .offset(y: -size * 0.22)
                    .rotationEffect(.degrees(angleDegrees))
            }
            .frame(width: size, height: size)
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        if dragStartValue == nil { dragStartValue = value }
                        let start = dragStartValue ?? value
                        let startFraction = scale.toFraction(start, range: range)
                        let deltaFraction = Float(-drag.translation.height / sweepDistance)
                        value = scale.fromFraction(startFraction + deltaFraction, range: range)
                    }
                    .onEnded { _ in dragStartValue = nil }
            )
            .accessibilityElement()
            .accessibilityLabel(label)
            .accessibilityValue(formatter(value))
            .accessibilityAdjustableAction { direction in
                let step = (range.upperBound - range.lowerBound) * 0.02
                switch direction {
                case .increment: value = min(value + step, range.upperBound)
                case .decrement: value = max(value - step, range.lowerBound)
                default: break
                }
            }

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(formatter(value))
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }

    private var angleDegrees: Double {
        let fraction = Double(scale.toFraction(value, range: range))
        return minAngle + fraction * (maxAngle - minAngle)
    }
}
