import Foundation

/// Starter presets shipped with the app so a fresh install has something to play
/// with immediately, rather than an empty preset list. `PresetStore` seeds these on
/// first launch only (detected by the absence of any saved data at all) - deleting
/// them is respected and they won't come back. Fixed UUIDs (rather than random) so a
/// future app update could target/update a specific factory preset by id instead of
/// only ever appending duplicates.
enum FactoryPresets {
    private static let referenceDate = Date(timeIntervalSince1970: 1_700_000_000)

    static let all: [SynthPreset] = [
        seaSirenCall, starryRoad, seaWreckage, lingering, voyager, hedgeLead, wobbleBass, concreteHallway,
        nightFerry, tidalDrone, undertow, saltFlats, copperWireLead, tarPitBass, glassBell, rustBloom,
        quarryEcho, paperMoth, halogenBuzz, driftPad,
    ]

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

    static let hedgeLead = SynthPreset(
        id: UUID(uuidString: "74692929-578E-4055-8B43-85AE065D5F99")!,
        name: "Hedge Lead", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 8.8894, vcoPulseWidth: 0.9315, vcoPwmSource: .manual,
        mixSawLevel: 0.7682, mixPulseLevel: 0.7953, mixSubLevel: 0.5558, mixNoiseLevel: 0.2827, mixSubMode: .minus2Square,
        filterCutoff: 177.7805, filterResonance: 0.3362, filterEnvAmount: 0.6939, filterLfoOn: false, filterKeyFollow: 0.3259,
        attack: 0.004, decay: 0.8574, sustain: 0.6414, release: 2.5405,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.8581, lfoDepth: 0.0298, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 3.6994, benderVcfSens: 3.1701, portamentoTime: 0.4227, portamentoOn: false,
        echoVolume: 0.1374, echoTime: 0.3824, echoRepeat: 0.276,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let wobbleBass = SynthPreset(
        id: UUID(uuidString: "E8309478-0A34-4351-9D60-C86569B885F3")!,
        name: "Wobble Bass", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.1111, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.0816, mixPulseLevel: 0.4113, mixSubLevel: 0.4823, mixNoiseLevel: 0.1312, mixSubMode: .minus2Square,
        filterCutoff: 1393.3752, filterResonance: 0.3411, filterEnvAmount: -0.2667, filterLfoOn: true, filterKeyFollow: 1,
        attack: 0.0038, decay: 0.15, sustain: 0.7067, release: 0.8992,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 5, lfoDepth: 0.26, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.15, portamentoOn: false,
        echoVolume: 0.1374, echoTime: 0.3732, echoRepeat: 0.3796,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let concreteHallway = SynthPreset(
        id: UUID(uuidString: "071BE8A8-783E-494B-AA49-D73FE97989F5")!,
        name: "Concrete hallway", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 8.7731, vcoPulseWidth: 0.363, vcoPwmSource: .env,
        mixSawLevel: 0, mixPulseLevel: 0, mixSubLevel: 0, mixNoiseLevel: 0.7163, mixSubMode: .minus2Pulse,
        filterCutoff: 64.9788, filterResonance: 0.8368, filterEnvAmount: 0.58, filterLfoOn: true, filterKeyFollow: 0.9264,
        attack: 0.0054, decay: 3, sustain: 0.8483, release: 0.0985,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 1.8454, lfoDepth: 0.4192, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 1, arpHold: true, arpRate: 6.5166,
        benderVcoSens: 6.4667, benderVcfSens: 0.8567, portamentoTime: 0.0228, portamentoOn: false,
        echoVolume: 0.8685, echoTime: 0.4216, echoRepeat: 0.7137,
        limiterThreshold: -11.4229, limiterCeiling: 0
    )

    static let nightFerry = SynthPreset(
        id: UUID(uuidString: "38689C71-E63F-4469-99B4-6734BEFA2EEC")!,
        name: "Night Ferry", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -3.4, vcoPulseWidth: 0.42, vcoPwmSource: .lfo,
        mixSawLevel: 0.42, mixPulseLevel: 0.38, mixSubLevel: 0.62, mixNoiseLevel: 0.18, mixSubMode: .minus2Square,
        filterCutoff: 520, filterResonance: 0.28, filterEnvAmount: 0.35, filterLfoOn: true, filterKeyFollow: 0.3,
        attack: 0.9, decay: 0.6, sustain: 0.75, release: 2.2,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.35, lfoDepth: 0.45, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 2, arpHold: true, arpRate: 3.2,
        benderVcoSens: 2.5, benderVcfSens: 0.8, portamentoTime: 0.6, portamentoOn: false,
        echoVolume: 0.55, echoTime: 1.8, echoRepeat: 0.55,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let tidalDrone = SynthPreset(
        id: UUID(uuidString: "D63F3591-6784-4499-B768-ECE80C52FFB5")!,
        name: "Tidal Drone", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 1.2, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.55, mixPulseLevel: 0.5, mixSubLevel: 0.85, mixNoiseLevel: 0.25, mixSubMode: .minus1Square,
        filterCutoff: 320, filterResonance: 0.4, filterEnvAmount: 0.15, filterLfoOn: true, filterKeyFollow: 0.15,
        attack: 2.4, decay: 1.2, sustain: 0.9, release: 3.8,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.18, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.4, portamentoTime: 1.8, portamentoOn: true,
        echoVolume: 0.42, echoTime: 2.6, echoRepeat: 0.62,
        limiterThreshold: -5, limiterCeiling: 0
    )

    static let undertow = SynthPreset(
        id: UUID(uuidString: "C5382851-B589-4291-859C-60BAE1CF0FC6")!,
        name: "Undertow", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.5, vcoPulseWidth: 0.55, vcoPwmSource: .env,
        mixSawLevel: 0.15, mixPulseLevel: 0.35, mixSubLevel: 0.95, mixNoiseLevel: 0.05, mixSubMode: .minus1Square,
        filterCutoff: 210, filterResonance: 0.5, filterEnvAmount: 0.6, filterLfoOn: false, filterKeyFollow: 0.6,
        attack: 0.003, decay: 0.28, sustain: 0.55, release: 0.5,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 2.8, lfoDepth: 0.3, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 1, arpHold: true, arpRate: 4.5,
        benderVcoSens: 3, benderVcfSens: 1.2, portamentoTime: 0.08, portamentoOn: false,
        echoVolume: 0.25, echoTime: 0.3, echoRepeat: 0.3,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let saltFlats = SynthPreset(
        id: UUID(uuidString: "B47990BF-3945-439F-87B6-51E3C9A4C4BA")!,
        name: "Salt Flats", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 5.5, vcoPulseWidth: 0.6, vcoPwmSource: .lfo,
        mixSawLevel: 0.7, mixPulseLevel: 0.65, mixSubLevel: 0.2, mixNoiseLevel: 0.12, mixSubMode: .minus2Pulse,
        filterCutoff: 4200, filterResonance: 0.15, filterEnvAmount: 0.4, filterLfoOn: true, filterKeyFollow: 0.5,
        attack: 1.1, decay: 0.8, sustain: 0.85, release: 1.6,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.6, lfoDepth: 0.35, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 4, benderVcfSens: 1, portamentoTime: 0.4, portamentoOn: false,
        echoVolume: 0.35, echoTime: 0.9, echoRepeat: 0.4,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let copperWireLead = SynthPreset(
        id: UUID(uuidString: "EFDB2FAB-4E9C-41AA-B223-5C8FB34DBFC7")!,
        name: "Copper Wire Lead", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 6.2, vcoPulseWidth: 0.25, vcoPwmSource: .manual,
        mixSawLevel: 0.85, mixPulseLevel: 0.6, mixSubLevel: 0.1, mixNoiseLevel: 0.05, mixSubMode: .minus2Square,
        filterCutoff: 2800, filterResonance: 0.45, filterEnvAmount: 0.5, filterLfoOn: false, filterKeyFollow: 0.4,
        attack: 0.005, decay: 0.35, sustain: 0.6, release: 0.4,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 6.5, lfoDepth: 0.12, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 5, benderVcfSens: 2.5, portamentoTime: 0.12, portamentoOn: false,
        echoVolume: 0.22, echoTime: 0.28, echoRepeat: 0.25,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let tarPitBass = SynthPreset(
        id: UUID(uuidString: "616C354C-95F5-49E0-B6AA-75D8E0AE4C1C")!,
        name: "Tar Pit Bass", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.3, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.3, mixPulseLevel: 0.55, mixSubLevel: 0.75, mixNoiseLevel: 0.08, mixSubMode: .minus2Square,
        filterCutoff: 180, filterResonance: 0.55, filterEnvAmount: -0.3, filterLfoOn: false, filterKeyFollow: 0.7,
        attack: 0.004, decay: 0.22, sustain: 0.5, release: 0.35,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 1.2, lfoDepth: 0.15, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.15, portamentoOn: false,
        echoVolume: 0.1, echoTime: 0.2, echoRepeat: 0.15,
        limiterThreshold: -2, limiterCeiling: -1
    )

    static let glassBell = SynthPreset(
        id: UUID(uuidString: "B6B07618-FA4B-45CD-B3E3-A433EA78C120")!,
        name: "Glass Bell", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 0.6, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.5, mixPulseLevel: 0.75, mixSubLevel: 0.05, mixNoiseLevel: 0, mixSubMode: .minus2Pulse,
        filterCutoff: 5200, filterResonance: 0.35, filterEnvAmount: 0.75, filterLfoOn: false, filterKeyFollow: 0.85,
        attack: 0.002, decay: 1.4, sustain: 0.08, release: 1.1,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 4.5, lfoDepth: 0.05, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.02, portamentoOn: false,
        echoVolume: 0.4, echoTime: 0.42, echoRepeat: 0.35,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let rustBloom = SynthPreset(
        id: UUID(uuidString: "6AD9D44E-8E96-4E80-82A8-726471C5DCC2")!,
        name: "Rust Bloom", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 12.4, vcoPulseWidth: 0.68, vcoPwmSource: .env,
        mixSawLevel: 0.6, mixPulseLevel: 0.4, mixSubLevel: 0.15, mixNoiseLevel: 0.3, mixSubMode: .minus2Pulse,
        filterCutoff: 1650, filterResonance: 0.6, filterEnvAmount: 0.55, filterLfoOn: false, filterKeyFollow: 0.5,
        attack: 0.003, decay: 0.9, sustain: 0.15, release: 0.8,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 8.2, lfoDepth: 0.2, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 3.5, benderVcfSens: 1.5, portamentoTime: 0.05, portamentoOn: false,
        echoVolume: 0.3, echoTime: 0.5, echoRepeat: 0.45,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let quarryEcho = SynthPreset(
        id: UUID(uuidString: "BB331AD3-C3D4-4553-8C9D-533E8E7A5140")!,
        name: "Quarry Echo", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -5.6, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0, mixPulseLevel: 0.1, mixSubLevel: 0.2, mixNoiseLevel: 0.85, mixSubMode: .minus2Pulse,
        filterCutoff: 900, filterResonance: 0.7, filterEnvAmount: 0.4, filterLfoOn: true, filterKeyFollow: 0.6,
        attack: 0.002, decay: 0.15, sustain: 0.05, release: 0.1,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 3.6, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 1, arpHold: true, arpRate: 7.8,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.01, portamentoOn: false,
        echoVolume: 0.75, echoTime: 0.55, echoRepeat: 0.68,
        limiterThreshold: -8, limiterCeiling: 0
    )

    static let paperMoth = SynthPreset(
        id: UUID(uuidString: "876EFE0B-B083-4E5E-ADA4-5FD2941BAF0D")!,
        name: "Paper Moth", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -1.8, vcoPulseWidth: 0.45, vcoPwmSource: .lfo,
        mixSawLevel: 0.28, mixPulseLevel: 0.32, mixSubLevel: 0.1, mixNoiseLevel: 0.4, mixSubMode: .minus1Square,
        filterCutoff: 3100, filterResonance: 0.2, filterEnvAmount: 0.2, filterLfoOn: true, filterKeyFollow: 0.3,
        attack: 0.4, decay: 0.5, sustain: 0.45, release: 0.9,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 5.8, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.6, portamentoTime: 0.2, portamentoOn: false,
        echoVolume: 0.3, echoTime: 0.3, echoRepeat: 0.3,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let halogenBuzz = SynthPreset(
        id: UUID(uuidString: "52453433-82D9-42CE-85A1-602B7C82F7A0")!,
        name: "Halogen Buzz", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 15.7, vcoPulseWidth: 0.35, vcoPwmSource: .manual,
        mixSawLevel: 0.9, mixPulseLevel: 0.85, mixSubLevel: 0.05, mixNoiseLevel: 0.15, mixSubMode: .minus2Square,
        filterCutoff: 2200, filterResonance: 0.65, filterEnvAmount: 0.3, filterLfoOn: false, filterKeyFollow: 0.2,
        attack: 0.003, decay: 0.12, sustain: 0.7, release: 0.15,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 12.5, lfoDepth: 0.25, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 2, arpHold: false, arpRate: 11.2,
        benderVcoSens: 6, benderVcfSens: 3, portamentoTime: 0.03, portamentoOn: false,
        echoVolume: 0.2, echoTime: 0.18, echoRepeat: 0.2,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let driftPad = SynthPreset(
        id: UUID(uuidString: "7910F8D6-9C5C-457E-BB79-41A3A4725409")!,
        name: "Drift Pad", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0.8, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.5, mixPulseLevel: 0.45, mixSubLevel: 0.4, mixNoiseLevel: 0.08, mixSubMode: .minus1Square,
        filterCutoff: 1450, filterResonance: 0.22, filterEnvAmount: 0.25, filterLfoOn: true, filterKeyFollow: 0.4,
        attack: 1.8, decay: 1.0, sustain: 0.8, release: 2.6,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.25, lfoDepth: 0.4, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.9, portamentoOn: true,
        echoVolume: 0.45, echoTime: 1.2, echoRepeat: 0.5,
        limiterThreshold: -4, limiterCeiling: 0
    )
}
