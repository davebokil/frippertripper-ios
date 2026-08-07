import AVFoundation

/// Owns the AVAudioEngine graph: a single fused AVAudioSourceNode (backed by
/// SynthEngineCore) -> mainMixerNode -> output. `SynthEngine` (the SwiftUI view
/// model) drives `core` directly for parameters and note events; this type only
/// owns the graph lifecycle and the AVAudioSession.
@MainActor
final class AudioEngineController: ObservableObject {
    private let engine = AVAudioEngine()
    let core = SynthEngineCore()
    private let sessionManager = AVAudioSessionManager()
    private var sourceNode: AVAudioSourceNode?

    @Published private(set) var isRunning = false

    func start() {
        guard !isRunning else { return }

        do {
            try sessionManager.activate()
        } catch {
            print("AudioEngineController: failed to activate session: \(error)")
            return
        }

        let sampleRate = sessionManager.sampleRate
        core.prepare(sampleRate: sampleRate)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            return
        }

        let node = AVAudioSourceNode(format: format, renderBlock: Self.makeRenderBlock(core: core))

        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        sourceNode = node

        do {
            try engine.start()
            isRunning = true
        } catch {
            print("AudioEngineController: failed to start engine: \(error)")
            engine.detach(node)
            sourceNode = nil
        }
    }

    func stop() {
        guard isRunning else { return }
        engine.stop()
        sessionManager.deactivate()
        isRunning = false
    }

    /// `nonisolated` (and `static`, so it captures no `self`) so the returned closure
    /// carries no actor isolation regardless of the module's default-isolation
    /// setting. AVAudioSourceNode invokes this on Core Audio's real-time thread; if
    /// Swift infers it as MainActor-isolated (which a closure literal formed inside an
    /// ordinary method of this @MainActor class can be, depending on build settings),
    /// the runtime's actor-isolation assertion fires and crashes on the first render
    /// call, since that thread is never the main thread.
    nonisolated private static func makeRenderBlock(core: SynthEngineCore) -> AVAudioSourceNodeRenderBlock {
        { _, _, frameCount, audioBufferList -> OSStatus in
            let bufferList = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let raw = bufferList[0].mData else { return noErr }
            let buffer = raw.assumingMemoryBound(to: Float.self)
            core.render(frameCount: Int(frameCount), into: buffer)
            return noErr
        }
    }
}
