import SwiftUI

enum SliderOrientation {
    case vertical, horizontal
}

/// Drag-to-position fader (position-based, not delta-based - matches the source's
/// `Slider.vue`, which reads pointer position directly rather than accumulating drag
/// distance).
struct SliderView: View {
    let label: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    var orientation: SliderOrientation = .vertical
    var scale: ControlScale = .linear
    var length: CGFloat = 110

    @Environment(\.panelControlScale) private var controlScale

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                let trackLength = orientation == .vertical ? geo.size.height : geo.size.width
                let fraction = CGFloat(scale.toFraction(value, range: range))

                ZStack(alignment: orientation == .vertical ? .bottom : .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(white: 0.14))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.brandOrange.opacity(0.7))
                        .frame(
                            width: orientation == .vertical ? nil : max(trackLength * fraction, 4),
                            height: orientation == .vertical ? max(trackLength * fraction, 4) : nil
                        )
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            let position: Float = orientation == .vertical
                                ? 1 - Float(drag.location.y / trackLength)
                                : Float(drag.location.x / trackLength)
                            value = scale.fromFraction(position, range: range)
                        }
                )
            }
            .frame(
                width: orientation == .vertical ? 26 * controlScale : length * controlScale,
                height: orientation == .vertical ? length * controlScale : 26 * controlScale
            )

            Text(label)
                .font(.system(size: 10 * controlScale, weight: .medium))
                .foregroundStyle(.secondary)
        }
    }
}
