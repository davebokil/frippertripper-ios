import SwiftUI

/// Phase 2 throwaway UI: validates the AVAudioEngine plumbing end-to-end with a
/// single hold-to-play tone. Replaced by the full front-panel/keyboard/FX surface
/// in Phase 5.
struct ContentView: View {
    @EnvironmentObject private var engine: AudioEngineController
    @State private var isHolding = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Frippertripper")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text("Phase 3 scaffold — prime the engine, then hold the circle to play the full VCO/VCF/envelope voice at 220Hz.")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button {
                    engine.start()
                } label: {
                    Text(engine.isRunning ? "Engine Running" : "Prime Engine")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background((engine.isRunning ? Color.green : Color.blue).opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 40)

                Circle()
                    .fill(isHolding ? Color.orange : Color.gray.opacity(0.3))
                    .frame(width: 140, height: 140)
                    .overlay(Text("HOLD").font(.headline).foregroundStyle(.white))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                guard !isHolding else { return }
                                isHolding = true
                                engine.noteOn(frequency: 220)
                            }
                            .onEnded { _ in
                                isHolding = false
                                engine.noteOff()
                            }
                    )
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AudioEngineController())
}
