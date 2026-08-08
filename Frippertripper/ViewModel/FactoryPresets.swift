import Foundation

/// Starter presets shipped with the app so a fresh install has something to play
/// with immediately, rather than an empty preset list. `PresetStore` seeds these on
/// first launch only (detected by the absence of any saved data at all) - deleting
/// them is respected and they won't come back. Fixed UUIDs (rather than random) so a
/// future app update could target/update a specific factory preset by id instead of
/// only ever appending duplicates.
enum FactoryPresets {
    private static let referenceDate = Date(timeIntervalSince1970: 1_700_000_000)

    static let all: [SynthPreset] = [warmPad, aggressiveArpBass, bellPluck, ambientDrone, classicLead, frippertripperLooper]

    static let warmPad = SynthPreset(
        id: UUID(uuidString: "3ECB2E8A-938C-4026-B168-31F7AF6F193C")!,
        name: "Warm Pad", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.4, mixPulseLevel: 0.3, mixSubLevel: 0.2, mixNoiseLevel: 0, mixSubMode: .minus1Square,
        filterCutoff: 1200, filterResonance: 0.25, filterEnvAmount: 0.3, filterLfoOn: false, filterKeyFollow: 0.5,
        attack: 0.8, decay: 0.6, sustain: 0.8, release: 1.5,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 4, lfoDepth: 0.15, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 1, portamentoTime: 0.3, portamentoOn: true,
        echoVolume: 0.35, echoTime: 0.4, echoRepeat: 0.3,
        limiterThreshold: -6, limiterCeiling: 0
    )

    static let aggressiveArpBass = SynthPreset(
        id: UUID(uuidString: "7D01BC75-069C-4239-BE9B-C5A40444FC5B")!,
        name: "Aggressive Arp Bass", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0, vcoPulseWidth: 0.5, vcoPwmSource: .env,
        mixSawLevel: 0.6, mixPulseLevel: 0.5, mixSubLevel: 0.5, mixNoiseLevel: 0, mixSubMode: .minus1Square,
        filterCutoff: 800, filterResonance: 0.6, filterEnvAmount: 0.7, filterLfoOn: false, filterKeyFollow: 0.3,
        attack: 0.002, decay: 0.15, sustain: 0.3, release: 0.1,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 8, lfoDepth: 0, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 2, arpHold: false, arpRate: 10,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.05, portamentoOn: false,
        echoVolume: 0.15, echoTime: 0.2, echoRepeat: 0.2,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let bellPluck = SynthPreset(
        id: UUID(uuidString: "2C23E045-323C-4B61-AD9B-9F27FD87449E")!,
        name: "Bell Pluck", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 0, vcoPulseWidth: 0.3, vcoPwmSource: .manual,
        mixSawLevel: 0.2, mixPulseLevel: 0.7, mixSubLevel: 0, mixNoiseLevel: 0.05, mixSubMode: .minus2Pulse,
        filterCutoff: 4500, filterResonance: 0.5, filterEnvAmount: 0.6, filterLfoOn: false, filterKeyFollow: 0.8,
        attack: 0.001, decay: 0.5, sustain: 0.05, release: 0.4,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 5, lfoDepth: 0, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.15, portamentoOn: false,
        echoVolume: 0.4, echoTime: 0.3, echoRepeat: 0.5,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let ambientDrone = SynthPreset(
        id: UUID(uuidString: "2EE2E55E-3DFB-462D-B7E1-2AE3AEFC9E7A")!,
        name: "Ambient Drone", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 5, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.5, mixPulseLevel: 0.2, mixSubLevel: 0.3, mixNoiseLevel: 0.1, mixSubMode: .minus1Square,
        filterCutoff: 600, filterResonance: 0.35, filterEnvAmount: 0.2, filterLfoOn: true, filterKeyFollow: 0.2,
        attack: 2.0, decay: 1.0, sustain: 0.9, release: 3.0,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.3, lfoDepth: 0.6, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 3, benderVcfSens: 2, portamentoTime: 1.0, portamentoOn: true,
        echoVolume: 0.6, echoTime: 1.2, echoRepeat: 0.75,
        limiterThreshold: -8, limiterCeiling: -1
    )

    static let classicLead = SynthPreset(
        id: UUID(uuidString: "E39672DD-D573-4560-A2F9-BE370778B225")!,
        name: "Classic Lead", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.7, mixPulseLevel: 0.3, mixSubLevel: 0, mixNoiseLevel: 0, mixSubMode: .minus1Square,
        filterCutoff: 2200, filterResonance: 0.4, filterEnvAmount: 0.45, filterLfoOn: false, filterKeyFollow: 0.6,
        attack: 0.01, decay: 0.3, sustain: 0.6, release: 0.3,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 5.5, lfoDepth: 0.1, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 1, portamentoTime: 0.12, portamentoOn: true,
        echoVolume: 0.25, echoTime: 0.25, echoRepeat: 0.25,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let frippertripperLooper = SynthPreset(
        id: UUID(uuidString: "FD6C8C1F-9601-4718-9833-81F0742DD94E")!,
        name: "Frippertripper Looper", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0, vcoPulseWidth: 0.7, vcoPwmSource: .lfo,
        mixSawLevel: 0.36, mixPulseLevel: 0.34, mixSubLevel: 0.38, mixNoiseLevel: 0.14, mixSubMode: .minus2Square,
        filterCutoff: 949, filterResonance: 0.44, filterEnvAmount: -0.31, filterLfoOn: true, filterKeyFollow: 0.28,
        attack: 1.44, decay: 0.406, sustain: 0.83, release: 0.384,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.1, lfoDepth: 0.82, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.15, portamentoOn: false,
        echoVolume: 0.58, echoTime: 4.0, echoRepeat: 1.0,
        limiterThreshold: -2, limiterCeiling: -1
    )
}
