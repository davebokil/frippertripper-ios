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

    var body: some View {
        TabView(selection: $selectedPage) {
            page {
                VcoPanelView(engine: engine)
                SourceMixerPanelView(engine: engine)
                FilterPanelView(engine: engine)
            }
            .tag(0)
            page {
                EnvelopePanelView(engine: engine)
                VcaPanelView(engine: engine)
                LfoPanelView(engine: engine)
            }
            .tag(1)
            page {
                ArpPanelView(engine: engine)
                ControllerPanelView(engine: engine)
                PanelButtonView(label: "Random") { engine.randomizeAll() }
            }
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    @ViewBuilder
    private func page(@ViewBuilder _ content: () -> some View) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                content()
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
    }
}

/// Titles for the front panel's 3 pages, shared with the tappable page selector.
let frontPanelPageTitles = ["VCO / Filter", "Envelope / LFO", "Arp / Controller"]
