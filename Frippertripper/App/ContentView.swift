import SwiftUI

/// Root layout: the full-screen front panel is the base layer (playable immediately
/// on launch, no landing/about page), with a top toolbar (page selector + FX button)
/// and a floating keyboard-reveal button overlaid - matching the product shape from
/// the plan.
struct ContentView: View {
    @State private var engine = SynthEngine()
    @State private var presetStore = PresetStore()
    @State private var selectedPage = 0
    @State private var isKeyboardOpen = true
    @State private var isFxPresented = false
    @State private var isPresetsPresented = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                titleRow
                topToolbar
                FrontPanelPagerView(engine: engine, selectedPage: $selectedPage, onPatchSelect: { isPresetsPresented = true })
            }

            if !isKeyboardOpen {
                VStack {
                    Spacer()
                    keyboardRevealButton
                }
                .padding()
            }

            if isKeyboardOpen {
                VStack {
                    Spacer()
                    KeyboardDrawerView(engine: engine, isPresented: $isKeyboardOpen)
                }
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
        .sheet(isPresented: $isFxPresented) {
            FxPanelView(engine: engine)
        }
        .sheet(isPresented: $isPresetsPresented) {
            PresetsView(engine: engine, presetStore: presetStore)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            engine.restoreLastSession()
            engine.audioEngineController.start()
        }
        .onChange(of: scenePhase) { _, newPhase in
            // Specifically .background, not "!= .active" - presenting any .sheet
            // (the FX/Presets panels) transiently flips scenePhase to
            // .inactive, which is a normal, common side effect of modal presentation
            // on iOS, not the app actually backgrounding. Stopping the engine there
            // tore down and reallocated the delay buffer while the render thread
            // could still be mid-flight against the old one - the actual root cause
            // of a crash reported "after moving echo dials" (opening the FX sheet to
            // reach them was what triggered the stop/reallocate race). Saving the
            // session here too, for the same reason: it's the reliable "app is about
            // to be suspended/killed" signal, without writing to UserDefaults on
            // every knob tweak.
            if newPhase == .background {
                engine.saveSession()
                engine.audioEngineController.stop()
            }
        }
    }

    private var titleRow: some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("FRIPPERTRIPPER")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .tracking(1.5)
                Text("SYNTH AND ECHO MACHINE")
                    .font(.system(size: 9, weight: .regular))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
    }

    private var topToolbar: some View {
        HStack(spacing: 10) {
            PageSelectorView(selectedPage: $selectedPage)
            toolbarIconButton(systemName: "dial.medium.fill") { isFxPresented = true }
            toolbarIconButton(systemName: "square.stack.3d.up") { isPresetsPresented = true }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private func toolbarIconButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color(white: 0.14))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var keyboardRevealButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isKeyboardOpen = true
            }
        } label: {
            Image(systemName: "pianokeys")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    ContentView()
}
