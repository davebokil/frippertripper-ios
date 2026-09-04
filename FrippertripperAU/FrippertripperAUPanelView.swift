import SwiftUI

/// The AUv3 extension's own view content (Stage 4, see docs/auv3-plan.md) - reuses
/// the standalone app's front-panel pager and FX sheet unmodified. Deliberately
/// excludes the on-screen piano keyboard (hosts supply their own MIDI input) and
/// the preset browser (that needs the App-Group-shared `PresetStore` wired up on
/// this side too, which is Stage 5's job). The page 2 panel's "Preset" button is
/// a no-op here until then.
struct FrippertripperAUPanelView: View {
    @Bindable var engine: SynthEngine
    @State private var selectedPage = 0
    @State private var isFxPresented = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                topToolbar
                FrontPanelPagerView(engine: engine, selectedPage: $selectedPage, onPatchSelect: {})
            }
        }
        .sheet(isPresented: $isFxPresented) {
            FxPanelView(engine: engine)
        }
        .preferredColorScheme(.dark)
    }

    private var topToolbar: some View {
        HStack(spacing: 10) {
            PageSelectorView(selectedPage: $selectedPage)
            Button {
                isFxPresented = true
            } label: {
                Image(systemName: "dial.medium.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color(white: 0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}
