import SwiftUI

/// The AUv3 extension's own view content (Stage 4/5, see docs/auv3-plan.md) -
/// reuses the standalone app's front-panel pager, FX sheet, and preset browser
/// unmodified. Deliberately excludes the on-screen piano keyboard (hosts supply
/// their own MIDI input). The preset browser works against the same
/// App-Group-shared `PresetStore` the standalone app uses (constructed with
/// `seedIfEmpty: false` by the caller - see `AudioUnitViewController`), so a
/// preset saved in the app shows up here and vice versa. Applying a preset goes
/// through `engine.apply(_:)`, which (like every other control in this reused
/// panel) routes through `SynthEngine.route(_:_:)` into the attached
/// `AUParameterTree` rather than writing `core` directly - so it produces the
/// same host-visible automation a knob turn would.
struct FrippertripperAUPanelView: View {
    @Bindable var engine: SynthEngine
    @Bindable var presetStore: PresetStore
    @State private var selectedPage = 0
    @State private var isFxPresented = false
    @State private var isPresetsPresented = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                topToolbar
                FrontPanelPagerView(engine: engine, selectedPage: $selectedPage, onPatchSelect: { isPresetsPresented = true })
            }
        }
        .sheet(isPresented: $isFxPresented) {
            FxPanelView(engine: engine)
        }
        .sheet(isPresented: $isPresetsPresented) {
            PresetsView(engine: engine, presetStore: presetStore)
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
