import SwiftUI

@main
struct FrippertripperApp: App {
    @StateObject private var engine = AudioEngineController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(engine)
                .preferredColorScheme(.dark)
        }
    }
}
