import AVFoundation

/// See docs/auv3-plan.md: real `SynthEngineCore` DSP, mono-rendered and
/// duplicated into a stereo output bus, driven by the host's MIDI note on/off
/// events plus an `AUParameterTree` for automation (`AUParameterMapping` holds
/// the address<->property mapping, shared with `Frippertripper`/`FrippertripperTests`),
/// plus a `fullState` override for host session save/restore (Stage 5).
final class FrippertripperAudioUnit: AUAudioUnit {
    /// Comfortably above any real host's block size (GarageBand for iOS uses
    /// 256; 4096 covers even unusually large hosts) so the scratch buffer can be
    /// allocated once, eagerly, in `init` - see `monoScratch`'s doc comment for
    /// why that matters.
    private static let maxScratchFrames = 4096

    private var outputBus: AUAudioUnitBus!
    private var _outputBusArray: AUAudioUnitBusArray!
    let core = SynthEngineCore()

    /// Allocated eagerly here (like `core`), not deferred to
    /// `allocateRenderResources()`. `internalRenderBlock`'s getter has no
    /// documented guarantee it's only ever queried *after*
    /// `allocateRenderResources()` has run - GarageBand for iOS, confirmed by
    /// on-device testing, reads it once early and caches whatever block comes
    /// back for the AU's entire lifetime, never re-querying it. A version of
    /// this that deferred allocation and returned a placeholder no-op block
    /// when `monoScratch` wasn't ready yet was silently, permanently broken as
    /// a result: `allocateRenderResources` would succeed, but the real render
    /// block backing MIDI/audio would simply never run again.
    private let monoScratch = UnsafeMutablePointer<Float>.allocate(capacity: FrippertripperAudioUnit.maxScratchFrames)
    private let parameterCache = ParameterValueCache(defaults: AUParameterTreeBuilder.defaultParameterValues())

    override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2) else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(kAudioUnitErr_FormatNotSupported))
        }
        outputBus = try AUAudioUnitBus(format: format)
        _outputBusArray = AUAudioUnitBusArray(audioUnit: self, busType: .output, busses: [outputBus])
        maximumFramesToRender = 512

        let tree = AUParameterTreeBuilder.makeTree()
        parameterTree = tree

        // UI-thread-originated sets (host generic UI, the reused SwiftUI panel)
        // go through here - not real-time, so writing straight onto `core`
        // (same as `AUParameterMapping.write` does off the render thread too) is
        // fine. Render-time automation events bypass this and write directly
        // from `internalRenderBlock` instead (see `makeRenderBlock`). Both paths
        // also update `parameterCache`, which is what `fullState` reads from -
        // see its doc comment for why that's not just `tree`/`core` directly.
        let core = self.core
        let cache = parameterCache
        tree.implementorValueObserver = { parameter, value in
            if let id = AUParameterID(rawValue: parameter.address) {
                cache.set(value, for: id)
            }
            AUParameterMapping.write(address: parameter.address, value: value, to: core)
        }
    }

    override var outputBusses: AUAudioUnitBusArray { _outputBusArray }

    override func allocateRenderResources() throws {
        try super.allocateRenderResources()

        core.prepare(sampleRate: outputBus.format.sampleRate)

        guard maximumFramesToRender <= AUAudioFrameCount(Self.maxScratchFrames) else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(kAudioUnitErr_TooManyFramesToProcess))
        }
    }

    deinit {
        monoScratch.deallocate()
    }

    /// Never render `SynthEngineCore` twice per block - that would double-advance
    /// oscillator/envelope/`RampedParameter` state, which is real per-sample
    /// mutable state. Render once into `monoScratch`, then duplicate into every
    /// output channel.
    override var internalRenderBlock: AUInternalRenderBlock {
        Self.makeRenderBlock(core: core, parameterCache: parameterCache, monoScratch: monoScratch, scratchCapacity: Self.maxScratchFrames)
    }

    /// `nonisolated` and `static` (captures no `self`) so the returned block carries
    /// no actor isolation regardless of build settings - this render block runs on
    /// Core Audio's real-time thread, never the main thread. Mirrors
    /// `AudioEngineController.makeRenderBlock`'s documented rationale.
    nonisolated private static func makeRenderBlock(
        core: SynthEngineCore,
        parameterCache: ParameterValueCache,
        monoScratch: UnsafeMutablePointer<Float>,
        scratchCapacity: Int
    ) -> AUInternalRenderBlock {
        { _, timestamp, frameCount, _, outputData, realtimeEventListHead, _ in
            let totalFrames = Int(frameCount)
            guard totalFrames <= scratchCapacity else { return kAudioUnitErr_TooManyFramesToProcess }

            // Sub-chunk the block at each MIDI event's sample-accurate position:
            // render up to the next event, apply it, then continue. `now` and
            // event `eventSampleTime`s share the same absolute host sample clock.
            var now = timestamp.pointee.mSampleTime
            var event = realtimeEventListHead
            var frameOffset = 0
            var framesRemaining = totalFrames

            while framesRemaining > 0 {
                while let current = event, current.pointee.head.eventSampleTime <= AUEventSampleTime(now) {
                    switch current.pointee.head.eventType {
                    case .MIDI:
                        handleMIDI(current.pointee.MIDI, core: core)
                    case .parameter, .parameterRamp:
                        let parameterEvent = current.pointee.parameter
                        if let id = AUParameterID(rawValue: parameterEvent.parameterAddress) {
                            parameterCache.set(parameterEvent.value, for: id)
                        }
                        AUParameterMapping.write(address: parameterEvent.parameterAddress, value: parameterEvent.value, to: core)
                    default:
                        break
                    }
                    event = UnsafePointer(current.pointee.head.next)
                }

                var framesThisSegment = framesRemaining
                if let next = event {
                    let framesUntilNext = Int(next.pointee.head.eventSampleTime - AUEventSampleTime(now))
                    if framesUntilNext > 0 {
                        framesThisSegment = min(framesThisSegment, framesUntilNext)
                    }
                }

                core.render(frameCount: framesThisSegment, into: monoScratch + frameOffset)

                frameOffset += framesThisSegment
                framesRemaining -= framesThisSegment
                now += Double(framesThisSegment)
            }

            let bufferList = UnsafeMutableAudioBufferListPointer(outputData)
            for buffer in bufferList {
                guard let raw = buffer.mData else { continue }
                raw.assumingMemoryBound(to: Float.self).update(from: monoScratch, count: totalFrames)
            }

            return noErr
        }
    }

    nonisolated private static func handleMIDI(_ midi: AUMIDIEvent, core: SynthEngineCore) {
        let status = midi.data.0 & 0xF0
        let note = Int(midi.data.1)
        let velocity = midi.data.2

        switch status {
        case 0x90 where velocity > 0:
            core.noteOn(id: note, frequency: midiToFrequency(note))
        case 0x90, 0x80:
            core.noteOff(id: note)
        default:
            break
        }
    }

    // MARK: - Stage 5: host session save/restore

    private static let fullStateVersionKey = "FrippertripperAUStateVersion"
    private static let fullStateParameterValuesKey = "FrippertripperAUParameterValues"

    /// Deliberately doesn't call `super.fullState`/`super.fullState = newValue` -
    /// this fully owns session state itself rather than layering on top of the
    /// base class's own parameter-tree-based default, to avoid two sources of
    /// truth disagreeing (see `parameterCache`'s doc comment for why the tree's
    /// own storage isn't trustworthy here). Distinct from `PresetStore`'s
    /// App-Group-shared preset *library* - this is per-host-session state only a
    /// DAW project file remembers.
    override var fullState: [String: Any]? {
        get {
            var values: [String: NSNumber] = [:]
            for id in AUParameterID.allCases {
                values["\(id)"] = NSNumber(value: parameterCache.value(for: id))
            }
            return [
                Self.fullStateVersionKey: NSNumber(value: 1),
                Self.fullStateParameterValuesKey: values,
            ]
        }
        set {
            guard let values = newValue?[Self.fullStateParameterValuesKey] as? [String: NSNumber] else { return }
            for id in AUParameterID.allCases {
                guard let number = values["\(id)"] else { continue }
                let value = number.floatValue
                parameterCache.set(value, for: id)
                AUParameterMapping.write(address: id.rawValue, value: value, to: core)
                // Keeps the host's own generic parameter UI in sync with the
                // restored session, not just `core`'s actual DSP state.
                parameterTree?.parameter(withAddress: id.rawValue)?.setValue(value, originator: nil)
            }
        }
    }
}

/// Per-instance cache of each parameter's last-written raw value, keyed by
/// `AUParameterID.rawValue`. `AUParameterTree`'s own internal value storage is
/// only trustworthy for writes that went *through* the tree
/// (`implementorValueObserver`) - render-time automation events
/// (`internalRenderBlock`'s `.parameter`/`.parameterRamp` handling) deliberately
/// write straight onto `core` instead, since calling `AUParameter.setValue` isn't
/// something Apple documents as real-time-safe. Two of the parameters
/// (echo/limiter) also have no direct getter on `SynthEngineCore` to reconstruct
/// from at all (only their *mapped* gain-domain values do). This cache is the one
/// place `fullState` can read a value that's simultaneously always up to date and
/// available for every parameter. Single-word Float reads/writes, same accepted
/// cross-thread-consistency trade-off as the rest of this codebase's real-time
/// parameter state (see `RampedParameter`'s doc comment).
private final class ParameterValueCache: @unchecked Sendable {
    private var values: [Float]

    init(defaults: [Float]) {
        values = defaults
    }

    func value(for id: AUParameterID) -> Float {
        values[Int(id.rawValue)]
    }

    func set(_ value: Float, for id: AUParameterID) {
        values[Int(id.rawValue)] = value
    }
}
