import SwiftUI

/// Horizontally-paged front panel: the full control inventory doesn't fit one phone
/// screen at a usable size, so it's split into pages rather than a deep vertical
/// scroll, keeping everything reachable while a note is held (per the plan).
///
/// Paging is driven by `selectedPage`, owned by the caller so it can render an
/// explicit, always-visible, tappable page selector alongside this view - swipe-only
/// paging with small system page dots wasn't a discoverable enough affordance for
/// "there are more parameters over here."
struct FrontPanelPagerView: View {
    @Bindable var engine: SynthEngine
    @Binding var selectedPage: Int
    var onPatchSelect: () -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// On a phone, panels stack in a single column (the layout this view was
    /// designed for). On iPad's regular width size class, that leaves one narrow
    /// column of panels with a large dead area beside and below them, so panels
    /// are arranged two-up instead to use the extra width.
    private var columns: [GridItem] {
        horizontalSizeClass == .regular
            ? [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
            : [GridItem(.flexible())]
    }

    private var controlScale: CGFloat {
        horizontalSizeClass == .regular ? 1.35 : 1
    }

    // Panels mixing different control types (knobs vs. tall sliders, or a lone
    // toggle vs. a row of knobs) naturally size to very different heights, which
    // reads as sloppy once panels sit side by side on iPad's 2-column grid. Each
    // page's panels report their natural height via `PanelHeightPreferenceKey`;
    // the tallest one measured is then fed back in as every panel's `matchedHeight`,
    // so the group settles on one uniform panel size instead of a hardcoded guess.
    // Phone stays single-column with each panel at its own natural height (matching
    // was never the issue there, and forcing it made short panels look padded/empty).
    @State private var page0MatchedHeight: CGFloat?
    @State private var page1MatchedHeight: CGFloat?

    private var isMatchingPanelHeights: Bool { horizontalSizeClass == .regular }

    var body: some View {
        TabView(selection: $selectedPage) {
            page {
                VcoPanelView(engine: engine, matchedHeight: isMatchingPanelHeights ? page0MatchedHeight : nil)
                SourceMixerPanelView(engine: engine, matchedHeight: isMatchingPanelHeights ? page0MatchedHeight : nil)
                FilterPanelView(engine: engine, matchedHeight: isMatchingPanelHeights ? page0MatchedHeight : nil)
            }
            .onPreferenceChange(PanelHeightPreferenceKey.self) { page0MatchedHeight = $0 }
            .tag(0)
            page {
                EnvelopePanelView(engine: engine, matchedHeight: isMatchingPanelHeights ? page1MatchedHeight : nil)
                VcaPanelView(engine: engine, matchedHeight: isMatchingPanelHeights ? page1MatchedHeight : nil)
                LfoPanelView(engine: engine, matchedHeight: isMatchingPanelHeights ? page1MatchedHeight : nil)
            }
            .onPreferenceChange(PanelHeightPreferenceKey.self) { page1MatchedHeight = $0 }
            .tag(1)
            page {
                ArpPanelView(engine: engine)
                ControllerPanelView(engine: engine)
                PanelSection(title: "Patch Browser") {
                    HStack(spacing: 12) {
                        PanelButtonView(label: "Init") { engine.resetToFactoryDefaults() }
                        PanelButtonView(label: "Preset", action: onPatchSelect)
                        PanelButtonView(label: "Random") { engine.randomizeAll() }
                    }
                }
            }
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .environment(\.panelControlScale, controlScale)
    }

    @ViewBuilder
    private func page(@ViewBuilder _ content: () -> some View) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                content()
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
    }
}

/// Titles for the front panel's 3 pages, shared with the tappable page selector.
let frontPanelPageTitles = ["VCO / Filter", "Env / LFO", "Arp / Cntrl"]
