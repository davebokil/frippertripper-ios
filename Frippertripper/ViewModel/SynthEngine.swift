import AVFoundation
import Foundation
import Observation

/// The Swift analog of the source's "module-singleton refs + `watch()` push into the
/// audio graph" pattern (`app/composables/useAudioEngine.ts`): one `@Observable`
/// instance, owned by the root view and passed down explicitly, exposing the full
/// ~35-parameter surface as plain properties. Each `didSet` routes the change through
/// `route(_:_:)` to `AUParameterMapping.write` - either straight onto `SynthEngineCore`
/// (standalone app) or through the AUv3 extension's `AUParameterTree` first, when one
/// is attached (see `auParameterTree`'s doc comment).
@MainActor
@Observable
final class SynthEngine {
    let core: SynthEngineCore
    private let onFirstNote: (() -> Void)?

    /// Set only by the AUv3 extension (`AudioUnitViewController`), after
    /// constructing this `SynthEngine` around the extension's own `core`. When
    /// present, every parameter write below routes through the tree instead of
    /// `core` directly, so twisting a knob in this reused SwiftUI panel produces
    /// the same host-visible `AUParameterTree` automation the host's own generic
    /// parameter UI would (docs/auv3-plan.md Stage 4's verification requirement).
    /// `nil` in the standalone app, which has no tree.
    var auParameterTree: AUParameterTree?

    init(core: SynthEngineCore, onFirstNote: (() -> Void)? = nil) {
        self.core = core
        self.onFirstNote = onFirstNote
    }

    /// Routes through `auParameterTree` when attached (which round-trips back to
    /// `AUParameterMapping.write` via `implementorValueObserver`) or calls it
    /// directly otherwise - either way there's exactly one place
    /// (`AUParameterMapping`) that knows how to turn a raw value into a write
    /// onto `core`.
    private func route(_ id: AUParameterID, _ rawValue: Float) {
        if let tree = auParameterTree, let parameter = tree.parameter(withAddress: id.rawValue) {
            parameter.setValue(rawValue, originator: nil)
        } else {
            AUParameterMapping.write(address: id.rawValue, value: rawValue, to: core)
        }
    }

    // MARK: - VCO
    var vcoRange: VcoRange = .eight { didSet { route(.vcoRange, AUParameterMapping.rawValue(for: vcoRange)) } }
    var vcoTune: Float = 3.7901 { didSet { route(.vcoTune, vcoTune) } }
    var vcoPulseWidth: Float = 0.9013 { didSet { route(.vcoPulseWidth, vcoPulseWidth) } }
    var vcoPwmSource: PwmSource = .manual { didSet { route(.vcoPwmSource, AUParameterMapping.rawValue(for: vcoPwmSource)) } }

    // MARK: - Source mixer
    var mixSawLevel: Float = 0.7441 { didSet { route(.mixSawLevel, mixSawLevel) } }
    var mixPulseLevel: Float = 0.5732 { didSet { route(.mixPulseLevel, mixPulseLevel) } }
    var mixSubLevel: Float = 0.1792 { didSet { route(.mixSubLevel, mixSubLevel) } }
    var mixNoiseLevel: Float = 0.202 { didSet { route(.mixNoiseLevel, mixNoiseLevel) } }
    var mixSubMode: SubMode = .minus2Pulse { didSet { route(.mixSubMode, AUParameterMapping.rawValue(for: mixSubMode)) } }

    // MARK: - Filter
    var filterCutoff: Float = 156.8622 { didSet { route(.filterCutoff, filterCutoff) } }
    var filterResonance: Float = 0.0593 { didSet { route(.filterResonance, filterResonance) } }
    var filterEnvAmount: Float = 0.8067 { didSet { route(.filterEnvAmount, filterEnvAmount) } }
    var filterLfoOn = false { didSet { route(.filterLfoOn, AUParameterMapping.rawValue(for: filterLfoOn)) } }
    var filterKeyFollow: Float = 0.0603 { didSet { route(.filterKeyFollow, filterKeyFollow) } }

    // MARK: - Envelope (shared by filter/PWM/VCA)
    var attack: Float = 0.2996 { didSet { route(.attack, attack) } }
    var decay: Float = 0.1853 { didSet { route(.decay, decay) } }
    var sustain: Float = 0.7622 { didSet { route(.sustain, sustain) } }
    var release: Float = 2.8338 { didSet { route(.release, release) } }

    // MARK: - VCA
    var vcaMode: VcaMode = .env { didSet { route(.vcaMode, AUParameterMapping.rawValue(for: vcaMode)) } }

    // MARK: - LFO
    var lfoWaveform: LfoWaveform = .triangle { didSet { route(.lfoWaveform, AUParameterMapping.rawValue(for: lfoWaveform)) } }
    var lfoRate: Float = 3.006 { didSet { route(.lfoRate, lfoRate) } }
    var lfoDepth: Float = 0.0308 { didSet { route(.lfoDepth, lfoDepth) } }
    var lfoToPitchOn = false { didSet { route(.lfoToPitchOn, AUParameterMapping.rawValue(for: lfoToPitchOn)) } }

    // MARK: - Arpeggiator
    var arpMode: ArpMode = .off { didSet { route(.arpMode, AUParameterMapping.rawValue(for: arpMode)) } }
    // `AUParameterTreeBuilder` advertises this as a 0-based indexed parameter
    // labeled ["1","2","3","4"]; `AUParameterMapping.write` adds 1 back on the
    // way in, so this side subtracts 1 on the way out.
    var arpOctaves: Int = 3 { didSet { route(.arpOctaves, Float(arpOctaves - 1)) } }
    var arpHold = false { didSet { route(.arpHold, AUParameterMapping.rawValue(for: arpHold)) } }
    var arpRate: Float = 14.1744 { didSet { route(.arpRate, arpRate) } }

    // MARK: - Controller
    var benderPosition: Float = 0 { didSet { route(.benderPosition, benderPosition) } }
    var benderVcoSens: Float = 0.3078 { didSet { route(.benderVcoSens, benderVcoSens) } }
    var benderVcfSens: Float = 0.1779 { didSet { route(.benderVcfSens, benderVcfSens) } }
    var portamentoTime: Float = 3.4664 { didSet { route(.portamentoTime, portamentoTime) } }
    var portamentoOn = false { didSet { route(.portamentoOn, AUParameterMapping.rawValue(for: portamentoOn)) } }

    // MARK: - Echo
    var echoVolume: Float = 0.6077 { didSet { route(.echoVolume, echoVolume) } }
    var echoTime: Float = 2.6569 { didSet { route(.echoTime, echoTime) } }
    var echoRepeat: Float = 0.6978 { didSet { route(.echoRepeat, echoRepeat) } }

    // MARK: - Limiter
    var limiterThreshold: Float = -3 { didSet { route(.limiterThreshold, limiterThreshold) } }
    var limiterCeiling: Float = 0 { didSet { route(.limiterCeiling, limiterCeiling) } }

    // MARK: - Note input

    /// Primes the engine (idempotent, matches the source's `primeAudioContext()`
    /// deferred-init pattern) and plays a note. Called from the piano keyboard.
    func noteOn(id: Int, frequency: Float) {
        onFirstNote?()
        core.noteOn(id: id, frequency: frequency)
    }

    func noteOff(id: Int) {
        core.noteOff(id: id)
    }

    /// Cuts short any ringing echo repeats without touching the dry signal, held
    /// notes, or any front-panel setting.
    func clearEcho() {
        core.clearEcho()
    }

    // MARK: - Randomize

    /// Port of the source's `randomizeAll()`: randomizes every front-panel control
    /// (VCO through envelope, LFO, controller sensitivities) but deliberately leaves
    /// the echo/limiter rack, arp settings, live bender position, and note state
    /// untouched.
    func randomizeAll() {
        vcoRange = [.sixteen, .eight, .four, .two].randomElement()!
        vcoTune = .random(in: -50...50)
        vcoPulseWidth = .random(in: 0.02...0.98)
        vcoPwmSource = [.manual, .env, .lfo].randomElement()!

        mixSawLevel = .random(in: 0...1)
        mixPulseLevel = .random(in: 0...1)
        mixSubLevel = .random(in: 0...1)
        mixNoiseLevel = .random(in: 0...1)
        mixSubMode = [.minus1Square, .minus2Square, .minus2Pulse].randomElement()!

        filterCutoff = randLog(80, 12000)
        filterResonance = .random(in: 0...0.8)
        filterEnvAmount = .random(in: -1...1)
        filterLfoOn = Bool.random(probabilityTrue: 0.35)
        filterKeyFollow = .random(in: 0...1)

        attack = randLog(0.001, 3)
        decay = randLog(0.02, 3)
        sustain = .random(in: 0...1)
        release = randLog(0.02, 5)

        vcaMode = [.env, .gate].randomElement()!

        lfoWaveform = [.triangle, .square, .sh, .noise].randomElement()!
        lfoRate = randLog(0.1, 30)
        lfoDepth = .random(in: 0...0.6)
        lfoToPitchOn = Bool.random(probabilityTrue: 0.35)

        benderVcoSens = .random(in: 0...12)
        benderVcfSens = .random(in: 0...4)
        portamentoTime = randLog(0.02, 5)
        portamentoOn = Bool.random(probabilityTrue: 0.3)
    }

    // MARK: - Reset

    /// Restores every persistent parameter to its factory-default value, via the
    /// same `apply(_:)` path a saved preset uses.
    func resetToFactoryDefaults() {
        apply(.factoryDefault)
    }

    // MARK: - Session persistence

    /// Snapshots every persistent parameter (the same set `SynthPreset` models -
    /// front panel, echo, limiter; not bender position or UI/keyboard state) so the
    /// next launch can pick up where this session left off, regardless of whether
    /// the sound started from a saved preset or was hand-tweaked. Call on
    /// backgrounding, not on every parameter change - one write per session is
    /// enough and avoids hammering `UserDefaults` while a knob is being dragged.
    func saveSession() {
        guard let data = try? JSONEncoder().encode(makePreset(name: "")) else { return }
        UserDefaults.standard.set(data, forKey: Self.lastSessionKey)
    }

    /// Restores the last-saved session snapshot, if any (none exists on a fresh
    /// install, in which case this leaves the engine at its declared defaults).
    /// Call once at launch, before starting the audio engine.
    func restoreLastSession() {
        guard let data = UserDefaults.standard.data(forKey: Self.lastSessionKey),
              let preset = try? JSONDecoder().decode(SynthPreset.self, from: data) else { return }
        apply(preset)
    }

    private static let lastSessionKey = "com.davebokil.frippertripper.lastSession"

    private func randLog(_ min: Float, _ max: Float) -> Float {
        let lo = log(min), hi = log(max)
        return exp(lo + Float.random(in: 0...1) * (hi - lo))
    }
}

private extension Bool {
    static func random(probabilityTrue: Double) -> Bool {
        Double.random(in: 0..<1) < probabilityTrue
    }
}
