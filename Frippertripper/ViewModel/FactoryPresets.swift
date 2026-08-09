import Foundation

/// Starter presets shipped with the app so a fresh install has something to play
/// with immediately, rather than an empty preset list. `PresetStore` seeds these on
/// first launch only (detected by the absence of any saved data at all) - deleting
/// them is respected and they won't come back. Fixed UUIDs (rather than random) so a
/// future app update could target/update a specific factory preset by id instead of
/// only ever appending duplicates.
enum FactoryPresets {
    private static let referenceDate = Date(timeIntervalSince1970: 1_700_000_000)

    static let all: [SynthPreset] = [looper, seaSirenCall, starryRoad, seaWreckage, lingering, voyager]

    static let looper = SynthPreset(
        id: UUID(uuidString: "FD6C8C1F-9601-4718-9833-81F0742DD94E")!,
        name: "Looper", createdAt: referenceDate,
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

    static let seaSirenCall = SynthPreset(
        id: UUID(uuidString: "A4994A23-7C80-4670-8B27-90C15DA95E51")!,
        name: "Sea Siren Call", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -8.2087, vcoPulseWidth: 0.374, vcoPwmSource: .manual,
        mixSawLevel: 0.3573, mixPulseLevel: 0.2483, mixSubLevel: 0.982, mixNoiseLevel: 0.9765, mixSubMode: .minus1Square,
        filterCutoff: 366.8985, filterResonance: 0.1312, filterEnvAmount: 0.7066, filterLfoOn: true, filterKeyFollow: 0.3952,
        attack: 0.3255, decay: 0.1408, sustain: 0.9048, release: 1.4949,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 10.8875, lfoDepth: 0.5705, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 2, arpHold: false, arpRate: 0.923,
        benderVcoSens: 8.4019, benderVcfSens: 1.4623, portamentoTime: 2.4802, portamentoOn: false,
        echoVolume: 0.3, echoTime: 1.384, echoRepeat: 0.5009,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let starryRoad = SynthPreset(
        id: UUID(uuidString: "64297CFE-9B6A-4CDD-ABDE-F6ED87394B7B")!,
        name: "Starry Road", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -0.2746, vcoPulseWidth: 0.3557, vcoPwmSource: .manual,
        mixSawLevel: 0.4435, mixPulseLevel: 0.7876, mixSubLevel: 0.8502, mixNoiseLevel: 0.3156, mixSubMode: .minus2Square,
        filterCutoff: 283.6264, filterResonance: 0.3673, filterEnvAmount: 0.6896, filterLfoOn: false, filterKeyFollow: 0.4318,
        attack: 0.006, decay: 1.9979, sustain: 0.0749, release: 0.1349,
        vcaMode: .env,
        lfoWaveform: .noise, lfoRate: 7.0515, lfoDepth: 0.5587, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 3, arpHold: true, arpRate: 14.1744,
        benderVcoSens: 10.413, benderVcfSens: 2.5064, portamentoTime: 0.0435, portamentoOn: false,
        echoVolume: 0.3002, echoTime: 0.2667, echoRepeat: 0.4708,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let seaWreckage = SynthPreset(
        id: UUID(uuidString: "FC0394F5-0A37-44A6-A98E-4D404D1A890D")!,
        name: "Sea Wreckage", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 33.7938, vcoPulseWidth: 0.721, vcoPwmSource: .manual,
        mixSawLevel: 0.8351, mixPulseLevel: 0.4823, mixSubLevel: 0.7163, mixNoiseLevel: 0.5779, mixSubMode: .minus2Square,
        filterCutoff: 1443.772, filterResonance: 0.5423, filterEnvAmount: -0.1131, filterLfoOn: true, filterKeyFollow: 0.3355,
        attack: 0.054, decay: 0.1624, sustain: 0.4887, release: 1.9541,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 0.1756, lfoDepth: 0.0481, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 3, arpHold: true, arpRate: 14.1744,
        benderVcoSens: 6.1882, benderVcfSens: 0.968, portamentoTime: 0.0464, portamentoOn: false,
        echoVolume: 0.4362, echoTime: 0.9378, echoRepeat: 0.6644,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let lingering = SynthPreset(
        id: UUID(uuidString: "48CD3BAC-AE3B-4DC1-A7D5-56813C265502")!,
        name: "Lingering", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -1.4078, vcoPulseWidth: 0.2568, vcoPwmSource: .env,
        mixSawLevel: 0.5869, mixPulseLevel: 0.6168, mixSubLevel: 0.8731, mixNoiseLevel: 0.9774, mixSubMode: .minus1Square,
        filterCutoff: 1329.3276, filterResonance: 0.4128, filterEnvAmount: 0.0508, filterLfoOn: false, filterKeyFollow: 0.5956,
        attack: 0.0047, decay: 0.0205, sustain: 0.2988, release: 3.1031,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 26.3411, lfoDepth: 0.4214, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 3, arpHold: false, arpRate: 14.1744,
        benderVcoSens: 8.6984, benderVcfSens: 3.3372, portamentoTime: 0.049, portamentoOn: false,
        echoVolume: 0.4362, echoTime: 0.9378, echoRepeat: 0.6644,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let voyager = SynthPreset(
        id: UUID(uuidString: "D50BB092-8864-4DFB-895C-2AECD1C95092")!,
        name: "Voyager", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 3.7901, vcoPulseWidth: 0.9013, vcoPwmSource: .manual,
        mixSawLevel: 0.7441, mixPulseLevel: 0.5732, mixSubLevel: 0.1792, mixNoiseLevel: 0.202, mixSubMode: .minus2Pulse,
        filterCutoff: 614.9666, filterResonance: 0.0593, filterEnvAmount: 0.6072, filterLfoOn: false, filterKeyFollow: 0.0603,
        attack: 0.5374, decay: 0.7146, sustain: 0.8524, release: 1.0608,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 3.006, lfoDepth: 0.0308, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 3, arpHold: false, arpRate: 14.1744,
        benderVcoSens: 0.3078, benderVcfSens: 0.1779, portamentoTime: 3.4664, portamentoOn: false,
        echoVolume: 0.4362, echoTime: 2.4236, echoRepeat: 0.8147,
        limiterThreshold: -3, limiterCeiling: 0
    )
}
