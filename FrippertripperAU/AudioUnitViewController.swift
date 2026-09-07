import CoreAudioKit
import SwiftUI

/// The extension's principal class (`NSExtensionPrincipalClass` in project.yml's
/// `info.properties`) — hosts must be able to instantiate this to get at
/// `createAudioUnit(with:)`, and it doubles as the view controller a host
/// presents for the plugin's own UI. Hosts don't guarantee the order of
/// `createAudioUnit(with:)` vs. `viewDidLoad` (confirmed on-device: GarageBand
/// for iOS calls `viewDidLoad` first), so `connectViewToAudioUnitIfPossible` is
/// called from both, guarded to only actually attach once both are ready.
final class AudioUnitViewController: AUViewController, AUAudioUnitFactory {
    // `AUAudioUnitFactory.createAudioUnit(with:)` is a nonisolated protocol
    // requirement, but `AUViewController` (a `UIViewController` subclass) is
    // `@MainActor` - `nonisolated(unsafe)` lets this stored property be written
    // from that nonisolated method. Safe because the host calls
    // `createAudioUnit(with:)` at most once per view-controller instance, well
    // before anything else touches `audioUnit`.
    nonisolated(unsafe) private var audioUnit: FrippertripperAudioUnit?
    private var hostingController: UIHostingController<FrippertripperAUPanelView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hosts (GarageBand in particular) size the container from this before
        // ever showing the view - without it there's no frame to hand the
        // hosted SwiftUI content, and the host silently skips the custom UI
        // instead of presenting a zero-size view.
        preferredContentSize = CGSize(width: 420, height: 700)
        connectViewToAudioUnitIfPossible()
    }

    nonisolated func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        let unit = try FrippertripperAudioUnit(componentDescription: componentDescription, options: [])
        audioUnit = unit
        DispatchQueue.main.async { [weak self] in
            self?.connectViewToAudioUnitIfPossible()
        }
        return unit
    }

    private func connectViewToAudioUnitIfPossible() {
        guard isViewLoaded, hostingController == nil, let audioUnit else { return }

        // No `onFirstNote` - unlike the standalone app, the extension's `core`
        // is already rendering as soon as the host loads it; there's no
        // deferred `AVAudioEngine` start to prime. `auParameterTree` is set
        // straight after so every knob in this reused panel routes through the
        // tree instead of writing `core` directly (see `SynthEngine.route(_:_:)`).
        let engine = SynthEngine(core: audioUnit.core)
        engine.auParameterTree = audioUnit.parameterTree
        let hosting = UIHostingController(rootView: FrippertripperAUPanelView(engine: engine))
        addChild(hosting)
        hosting.view.frame = view.bounds
        hosting.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
        hostingController = hosting
    }
}
