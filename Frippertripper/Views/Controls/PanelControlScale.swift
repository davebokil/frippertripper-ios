import SwiftUI

/// Uniform size multiplier for panel controls (knobs, switches, buttons, sliders).
/// Controls are sized for a phone by default; on iPad's regular width size class,
/// `FrontPanelPagerView` sets this higher so panels grow to fill the extra screen
/// space instead of staying phone-sized with more black space around them.
private struct PanelControlScaleKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1
}

extension EnvironmentValues {
    var panelControlScale: CGFloat {
        get { self[PanelControlScaleKey.self] }
        set { self[PanelControlScaleKey.self] = newValue }
    }
}
