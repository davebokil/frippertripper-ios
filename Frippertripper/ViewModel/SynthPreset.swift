import Foundation

/// A saved snapshot of every persistent synth/echo/limiter parameter - everything
/// `SynthEngine` exposes except the ephemeral bender position (spring-returns to 0
/// anyway) and live note/UI state (keyboard octave/hold, current page, etc.), which
/// aren't part of "how the instrument is set up."
struct SynthPreset: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var createdAt: Date

    // VCO
    var vcoRange: VcoRange
    var vcoTune: Float
    var vcoPulseWidth: Float
    var vcoPwmSource: PwmSource

    // Source mixer
    var mixSawLevel: Float
    var mixPulseLevel: Float
    var mixSubLevel: Float
    var mixNoiseLevel: Float
    var mixSubMode: SubMode

    // Filter
    var filterCutoff: Float
    var filterResonance: Float
    var filterEnvAmount: Float
    var filterLfoOn: Bool
    var filterKeyFollow: Float

    // Envelope
    var attack: Float
    var decay: Float
    var sustain: Float
    var release: Float

    // VCA
    var vcaMode: VcaMode

    // LFO
    var lfoWaveform: LfoWaveform
    var lfoRate: Float
    var lfoDepth: Float
    var lfoToPitchOn: Bool

    // Arpeggiator
    var arpMode: ArpMode
    var arpOctaves: Int
    var arpHold: Bool
    var arpRate: Float

    // Controller
    var benderVcoSens: Float
    var benderVcfSens: Float
    var portamentoTime: Float
    var portamentoOn: Bool

    // Echo
    var echoVolume: Float
    var echoTime: Float
    var echoRepeat: Float

    // Limiter
    var limiterThreshold: Float
    var limiterCeiling: Float

    /// Mirrors the default values declared on `SynthEngine`'s own properties -
    /// what a freshly-created engine starts with. Used by "Init" to restore those
    /// values through the same `apply(_:)` path a saved preset uses, rather than a
    /// separate hand-rolled reset function.
    static let factoryDefault = SynthPreset(
        id: UUID(), name: "Default", createdAt: Date(),
        vcoRange: .eight, vcoTune: 3.7901, vcoPulseWidth: 0.9013, vcoPwmSource: .manual,
        mixSawLevel: 0.7441, mixPulseLevel: 0.5732, mixSubLevel: 0.1792, mixNoiseLevel: 0.202, mixSubMode: .minus2Pulse,
        filterCutoff: 156.8622, filterResonance: 0.0593, filterEnvAmount: 0.8067, filterLfoOn: false, filterKeyFollow: 0.0603,
        attack: 0.2996, decay: 0.1853, sustain: 0.7622, release: 2.8338,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.006, lfoDepth: 0.0308, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 3, arpHold: false, arpRate: 14.1744,
        benderVcoSens: 0.3078, benderVcfSens: 0.1779, portamentoTime: 3.4664, portamentoOn: false,
        echoVolume: 0.6077, echoTime: 2.6569, echoRepeat: 0.6978,
        limiterThreshold: -3, limiterCeiling: 0
    )
}

extension SynthEngine {
    func makePreset(id: UUID = UUID(), name: String, createdAt: Date = Date()) -> SynthPreset {
        SynthPreset(
            id: id, name: name, createdAt: createdAt,
            vcoRange: vcoRange, vcoTune: vcoTune, vcoPulseWidth: vcoPulseWidth, vcoPwmSource: vcoPwmSource,
            mixSawLevel: mixSawLevel, mixPulseLevel: mixPulseLevel, mixSubLevel: mixSubLevel,
            mixNoiseLevel: mixNoiseLevel, mixSubMode: mixSubMode,
            filterCutoff: filterCutoff, filterResonance: filterResonance, filterEnvAmount: filterEnvAmount,
            filterLfoOn: filterLfoOn, filterKeyFollow: filterKeyFollow,
            attack: attack, decay: decay, sustain: sustain, release: release,
            vcaMode: vcaMode,
            lfoWaveform: lfoWaveform, lfoRate: lfoRate, lfoDepth: lfoDepth, lfoToPitchOn: lfoToPitchOn,
            arpMode: arpMode, arpOctaves: arpOctaves, arpHold: arpHold, arpRate: arpRate,
            benderVcoSens: benderVcoSens, benderVcfSens: benderVcfSens,
            portamentoTime: portamentoTime, portamentoOn: portamentoOn,
            echoVolume: echoVolume, echoTime: echoTime, echoRepeat: echoRepeat,
            limiterThreshold: limiterThreshold, limiterCeiling: limiterCeiling
        )
    }

    func apply(_ preset: SynthPreset) {
        vcoRange = preset.vcoRange
        vcoTune = preset.vcoTune
        vcoPulseWidth = preset.vcoPulseWidth
        vcoPwmSource = preset.vcoPwmSource

        mixSawLevel = preset.mixSawLevel
        mixPulseLevel = preset.mixPulseLevel
        mixSubLevel = preset.mixSubLevel
        mixNoiseLevel = preset.mixNoiseLevel
        mixSubMode = preset.mixSubMode

        filterCutoff = preset.filterCutoff
        filterResonance = preset.filterResonance
        filterEnvAmount = preset.filterEnvAmount
        filterLfoOn = preset.filterLfoOn
        filterKeyFollow = preset.filterKeyFollow

        attack = preset.attack
        decay = preset.decay
        sustain = preset.sustain
        release = preset.release

        vcaMode = preset.vcaMode

        lfoWaveform = preset.lfoWaveform
        lfoRate = preset.lfoRate
        lfoDepth = preset.lfoDepth
        lfoToPitchOn = preset.lfoToPitchOn

        arpMode = preset.arpMode
        arpOctaves = preset.arpOctaves
        arpHold = preset.arpHold
        arpRate = preset.arpRate

        benderVcoSens = preset.benderVcoSens
        benderVcfSens = preset.benderVcfSens
        portamentoTime = preset.portamentoTime
        portamentoOn = preset.portamentoOn

        echoVolume = preset.echoVolume
        echoTime = preset.echoTime
        echoRepeat = preset.echoRepeat

        limiterThreshold = preset.limiterThreshold
        limiterCeiling = preset.limiterCeiling

        // A ringing echo tail from whatever was playing before shouldn't bleed
        // into the newly-loaded sound.
        core.clearEcho()
    }
}
