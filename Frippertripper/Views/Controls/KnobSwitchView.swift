import SwiftUI

/// Same drag mechanic as `KnobView`, but snaps to one of a fixed set of discrete
/// options rather than a continuous range - matches the source's `KnobSwitch.vue`.
struct KnobSwitchView<Option: Equatable>: View {
    let label: String
    @Binding var selection: Option
    let options: [Option]
    let optionLabel: (Option) -> String
    var size: CGFloat = 52

    @State private var dragStartIndex: Int?

    private let sweepDistance: CGFloat = 180
    private let minAngle: Double = -135
    private let maxAngle: Double = 135

    private var currentIndex: Int { options.firstIndex(of: selection) ?? 0 }

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color(white: 0.22), Color(white: 0.12)], startPoint: .top, endPoint: .bottom))
                    .overlay(Circle().stroke(Color(white: 0.35), lineWidth: 1))
                Capsule()
                    .fill(Color.brandOrange)
                    .frame(width: 3, height: size * 0.32)
                    .offset(y: -size * 0.22)
                    .rotationEffect(.degrees(angleDegrees(for: currentIndex)))
            }
            .frame(width: size, height: size)
            .contentShape(Circle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        if dragStartIndex == nil { dragStartIndex = currentIndex }
                        guard options.count > 1 else { return }
                        let stepsMoved = Int((-drag.translation.height / sweepDistance * CGFloat(options.count - 1)).rounded())
                        let newIndex = min(max((dragStartIndex ?? 0) + stepsMoved, 0), options.count - 1)
                        selection = options[newIndex]
                    }
                    .onEnded { _ in dragStartIndex = nil }
            )

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)
            Text(optionLabel(selection))
                .font(.system(size: 9, design: .monospaced))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }

    private func angleDegrees(for index: Int) -> Double {
        guard options.count > 1 else { return minAngle }
        let fraction = Double(index) / Double(options.count - 1)
        return minAngle + fraction * (maxAngle - minAngle)
    }
}
