import AVFoundation

/// Thin wrapper around AVAudioSession. Category is `.playback` (no mic input needed);
/// activation is deferred until the caller explicitly primes the engine, mirroring the
/// source web app's `primeAudioContext()` first-gesture pattern.
final class AVAudioSessionManager {
    private let session = AVAudioSession.sharedInstance()

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
}
