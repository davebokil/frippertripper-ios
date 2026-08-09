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
