import AVFoundation

/// Thin wrapper around AVAudioSession. Category is `.playback` (no mic input needed);
/// activation is deferred until the caller explicitly primes the engine, mirroring the
/// source web app's `primeAudioContext()` first-gesture pattern.
///
/// Also owns interruption/route-change observation - genuinely new territory versus
/// the source app, which (being a browser tab) never had to deal with phone calls,
/// Siri, or headphones being unplugged interrupting playback.
final class AVAudioSessionManager {
    private let session = AVAudioSession.sharedInstance()
    private var interruptionObserver: NSObjectProtocol?
    private var routeChangeObserver: NSObjectProtocol?

    var sampleRate: Double {
        session.sampleRate > 0 ? session.sampleRate : 44100
    }

    func activate() throws {
        try session.setCategory(.playback, mode: .default, options: [])
        try session.setActive(true, options: [])
    }

    func deactivate() {
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
    }

    /// Handlers are invoked on the main thread (`queue: .main`).
    func startObserving(onInterruptionBegan: @escaping () -> Void, onInterruptionEnded: @escaping (_ shouldResume: Bool) -> Void) {
        let center = NotificationCenter.default

        interruptionObserver = center.addObserver(
            forName: AVAudioSession.interruptionNotification, object: session, queue: .main
        ) { notification in
            guard let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
            switch type {
            case .began:
                onInterruptionBegan()
            case .ended:
                var shouldResume = false
                if let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt {
                    shouldResume = AVAudioSession.InterruptionOptions(rawValue: optionsValue).contains(.shouldResume)
                }
                onInterruptionEnded(shouldResume)
            @unknown default:
                break
            }
        }

        // Route changes (headphones unplugged, AirPods disconnected, etc.) don't need
        // drastic handling - just observed so nothing crashes across one.
        routeChangeObserver = center.addObserver(forName: AVAudioSession.routeChangeNotification, object: session, queue: .main) { _ in }
    }

    func stopObserving() {
        if let observer = interruptionObserver { NotificationCenter.default.removeObserver(observer) }
        if let observer = routeChangeObserver { NotificationCenter.default.removeObserver(observer) }
        interruptionObserver = nil
        routeChangeObserver = nil
    }

    deinit {
        if let observer = interruptionObserver { NotificationCenter.default.removeObserver(observer) }
        if let observer = routeChangeObserver { NotificationCenter.default.removeObserver(observer) }
    }
}
