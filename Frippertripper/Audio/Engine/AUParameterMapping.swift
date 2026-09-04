import Foundation

/// Stable per-parameter addresses for the AUv3 extension's `AUParameterTree`
/// (see docs/auv3-plan.md Stage 3), grouped the same way as `SynthEngine.swift`'s
/// `// MARK:` sections for a clean 1:1 identifier mapping. Declared without
/// explicit raw values - Swift auto-increments from 0, and reordering/inserting a
/// case would silently renumber every case after it, which would break any
/// already-shipped host automation/session data keyed on these addresses. Once
/// this ships, only ever append new cases at the end.
enum AUParameterID: UInt64, CaseIterable {
    // MARK: - VCO
    case vcoRange, vcoTune, vcoPulseWidth, vcoPwmSource
    // MARK: - Source mixer
    case mixSawLevel, mixPulseLevel, mixSubLevel, mixNoiseLevel, mixSubMode
    // MARK: - Filter
    case filterCutoff, filterResonance, filterEnvAmount, filterLfoOn, filterKeyFollow
    // MARK: - Envelope (shared by filter/PWM/VCA)
    case attack, decay, sustain, release
    // MARK: - VCA
    case vcaMode
    // MARK: - LFO
    case lfoWaveform, lfoRate, lfoDepth, lfoToPitchOn
    // MARK: - Arpeggiator
    case arpMode, arpOctaves, arpHold, arpRate
    // MARK: - Controller
    case benderPosition, benderVcoSens, benderVcfSens, portamentoTime, portamentoOn
    // MARK: - Echo
    case echoVolume, echoTime, echoRepeat
    // MARK: - Limiter
    case limiterThreshold, limiterCeiling
}

/// The address<->property mapping behind the AUv3 extension's `AUParameterTree`,
/// factored out as a plain, `AUAudioUnit`-independent Swift type (per
/// docs/auv3-plan.md's Stage 3 testing note) so it's exercisable via
/// `@testable import Frippertripper` even though the standalone app never calls
/// it at runtime - only `FrippertripperAU` does. Mirrors `SynthEngine.swift`'s
/// didSet bodies property-for-property: same smoothing (`RampedParameter.setTarget`,
/// tau 0.01) for continuous knobs, same dedicated setters for echo/limiter, same
/// direct assignment for envelope/controller/discrete params.
enum AUParameterMapping {
    static func write(address: UInt64, value: Float, to core: SynthEngineCore) {
        guard let id = AUParameterID(rawValue: address) else { return }
        switch id {
        case .vcoRange: core.vcoRange = indexed(value, VcoRange.self)
        case .vcoTune: core.vcoTune = value
        case .vcoPulseWidth: core.vcoPulseWidthParam.setTarget(value, tau: 0.01)
        case .vcoPwmSource: core.vcoPwmSource = indexed(value, PwmSource.self)

        case .mixSawLevel: core.mixSawLevelParam.setTarget(value, tau: 0.01)
        case .mixPulseLevel: core.mixPulseLevelParam.setTarget(value, tau: 0.01)
        case .mixSubLevel: core.mixSubLevelParam.setTarget(value, tau: 0.01)
        case .mixNoiseLevel: core.mixNoiseLevelParam.setTarget(value, tau: 0.01)
        case .mixSubMode: core.mixSubMode = indexed(value, SubMode.self)

        case .filterCutoff: core.filterCutoffKnob = value
        case .filterResonance: core.filterResonanceParam.setTarget(value, tau: 0.01)
        case .filterEnvAmount: core.filterEnvAmountParam.setTarget(value, tau: 0.01)
        case .filterLfoOn: core.filterLfoOn = value >= 0.5
        case .filterKeyFollow: core.filterKeyFollow = value

        case .attack: core.attackSeconds = value
        case .decay: core.decaySeconds = value
        case .sustain: core.sustainLevel = value
        case .release: core.releaseSeconds = value

        case .vcaMode: core.vcaMode = indexed(value, VcaMode.self)

        case .lfoWaveform: core.lfoWaveform = indexed(value, LfoWaveform.self)
        case .lfoRate: core.lfoRateParam.setTarget(value, tau: 0.01)
        case .lfoDepth: core.lfoDepthParam.setTarget(value, tau: 0.01)
        case .lfoToPitchOn: core.lfoToPitchOn = value >= 0.5

        case .arpMode: core.arpMode = indexed(value, ArpMode.self)
        // `AUParameterTreeBuilder` declares this as a 0-based indexed parameter
        // with labels ["1","2","3","4"] (so hosts see a clean 1-4 display), but
        // `core.arpOctaves` wants the actual octave count - offset by 1.
        case .arpOctaves: core.arpOctaves = Int(value.rounded()) + 1
        case .arpHold: core.arpHold = value >= 0.5
        case .arpRate: core.arpRate = value

        case .benderPosition: core.benderPosition = value
        case .benderVcoSens: core.benderVcoSens = value
        case .benderVcfSens: core.benderVcfSens = value
        case .portamentoTime: core.portamentoTime = value
        case .portamentoOn: core.portamentoOn = value >= 0.5

        case .echoVolume: core.setEchoVolume(value)
        case .echoTime: core.setEchoTime(value)
        case .echoRepeat: core.setEchoRepeat(value)

        case .limiterThreshold: core.setLimiterThreshold(value)
        case .limiterCeiling: core.setLimiterCeiling(value)
        }
    }

    /// No corresponding `read` - by design, `implementorValueProvider` is left
    /// unset on the `AUParameterTree` (see `AUParameterTreeBuilder`), so each
    /// `AUParameter`'s own last-set value is the read source of truth rather than
    /// querying `core` back. That sidesteps two of `SynthEngineCore`'s
    /// echo/limiter parameters not exposing a raw-slider getter (only their
    /// *mapped* gain-domain values, via private `RampedParameter`s) and matches
    /// standard AUv3 practice for a DSP whose internal representation doesn't
    /// have a 1:1 inverse back to the host-facing value.
    private static func indexed<T: CaseIterable & Equatable>(_ value: Float, _ type: T.Type) -> T {
        let all = Array(T.allCases)
        let clamped = max(0, min(Int(value.rounded()), all.count - 1))
        return all[clamped]
    }

    /// The inverse of `indexed(_:_:)` - the raw index `write(address:value:to:)`
    /// expects for an indexed enum parameter. `SynthEngine`'s didSets call this
    /// (see its `route(_:_:)`) so the enum<->index correspondence lives in this
    /// one place rather than being re-derived at each call site.
    static func rawValue<T: CaseIterable & Equatable>(for value: T) -> Float {
        Float(Array(T.allCases).firstIndex(of: value) ?? 0)
    }

    static func rawValue(for flag: Bool) -> Float { flag ? 1 : 0 }
}
