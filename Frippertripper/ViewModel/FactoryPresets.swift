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
        driftPad, voyager, hedgeLead, seaWreckage, lingering, wobbleBass, concreteHallway,
        nightFerry, tidalDrone, undertow, saltFlats, copperWireLead, tarPitBass, glassBell, rustBloom,
        quarryEcho, paperMoth, halogenBuzz, seaSirenCall, starryRoad,
        amberGlassPad, ironGateDrone, winterStatic, mothWingFlutter, harborFog, brokenCompass, chromeVapor, slowTide,
        ashField, neonHallway, frostBloom, distantSignal, copperRain, sunkenBell, gravelRoad, staticBloom,
        lastTram, paleHorizon, wireFence, kelpForest, fadedPolaroid, steelDrizzle, lowTideBass, paperLantern,
        marshLight, dieselHum, velvetFog, boneDust, wanderingStar, crackedMirror,
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
        id: UUID(uuidString: "C0283FC7-B59C-464D-BD18-0BA34925F56F")!,
        name: "Voyager", createdAt: referenceDate,
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

    static let amberGlassPad = SynthPreset(
        id: UUID(uuidString: "159195BD-40AF-422A-8E8A-EAE73DCE5B4C")!,
        name: "Amber Glass Pad", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0.4, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.55, mixPulseLevel: 0.5, mixSubLevel: 0.3, mixNoiseLevel: 0.05, mixSubMode: .minus1Square,
        filterCutoff: 2100, filterResonance: 0.25, filterEnvAmount: 0.2, filterLfoOn: true, filterKeyFollow: 0.4,
        attack: 1.6, decay: 1.2, sustain: 0.85, release: 2.4,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.3, lfoDepth: 0.35, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.8, portamentoOn: true,
        echoVolume: 0.4, echoTime: 1.4, echoRepeat: 0.45,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let ironGateDrone = SynthPreset(
        id: UUID(uuidString: "F7820FD2-B285-4FB7-82D0-6389D611E46E")!,
        name: "Iron Gate Drone", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.6, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.4, mixPulseLevel: 0.35, mixSubLevel: 0.9, mixNoiseLevel: 0.1, mixSubMode: .minus1Square,
        filterCutoff: 140, filterResonance: 0.35, filterEnvAmount: 0.1, filterLfoOn: true, filterKeyFollow: 0.1,
        attack: 3.5, decay: 1.5, sustain: 0.95, release: 4.5,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.12, lfoDepth: 0.4, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1, benderVcfSens: 0.3, portamentoTime: 2.2, portamentoOn: true,
        echoVolume: 0.5, echoTime: 3.2, echoRepeat: 0.7,
        limiterThreshold: -5, limiterCeiling: 0
    )

    static let winterStatic = SynthPreset(
        id: UUID(uuidString: "55DB1E16-9CA2-4B05-AFE8-7A112592647D")!,
        name: "Winter Static", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 2.1, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.1, mixPulseLevel: 0.05, mixSubLevel: 0.15, mixNoiseLevel: 0.9, mixSubMode: .minus2Pulse,
        filterCutoff: 3800, filterResonance: 0.4, filterEnvAmount: 0.3, filterLfoOn: true, filterKeyFollow: 0.2,
        attack: 0.8, decay: 0.6, sustain: 0.3, release: 1.8,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 4.2, lfoDepth: 0.6, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 1, portamentoTime: 0.3, portamentoOn: false,
        echoVolume: 0.35, echoTime: 0.6, echoRepeat: 0.4,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let mothWingFlutter = SynthPreset(
        id: UUID(uuidString: "5EE13254-EBA0-45C7-A1D5-E90A5B610C31")!,
        name: "Moth Wing Flutter", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -2.4, vcoPulseWidth: 0.4, vcoPwmSource: .lfo,
        mixSawLevel: 0.25, mixPulseLevel: 0.3, mixSubLevel: 0.1, mixNoiseLevel: 0.35, mixSubMode: .minus1Square,
        filterCutoff: 2600, filterResonance: 0.2, filterEnvAmount: 0.25, filterLfoOn: true, filterKeyFollow: 0.35,
        attack: 0.35, decay: 0.4, sustain: 0.4, release: 0.7,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 7.5, lfoDepth: 0.45, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.5, portamentoTime: 0.15, portamentoOn: false,
        echoVolume: 0.3, echoTime: 0.25, echoRepeat: 0.3,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let harborFog = SynthPreset(
        id: UUID(uuidString: "F2230D19-37D2-4BA9-A705-F333B379AE8D")!,
        name: "Harbor Fog", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -1.1, vcoPulseWidth: 0.55, vcoPwmSource: .env,
        mixSawLevel: 0.45, mixPulseLevel: 0.4, mixSubLevel: 0.65, mixNoiseLevel: 0.2, mixSubMode: .minus2Square,
        filterCutoff: 480, filterResonance: 0.3, filterEnvAmount: 0.2, filterLfoOn: true, filterKeyFollow: 0.25,
        attack: 2.2, decay: 1.4, sustain: 0.8, release: 3.4,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.2, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.6, portamentoTime: 1.2, portamentoOn: true,
        echoVolume: 0.5, echoTime: 2.0, echoRepeat: 0.6,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let brokenCompass = SynthPreset(
        id: UUID(uuidString: "16C3796D-33E9-4581-9591-3D789694C109")!,
        name: "Broken Compass", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 4.8, vcoPulseWidth: 0.6, vcoPwmSource: .manual,
        mixSawLevel: 0.6, mixPulseLevel: 0.5, mixSubLevel: 0.2, mixNoiseLevel: 0.15, mixSubMode: .minus2Pulse,
        filterCutoff: 1500, filterResonance: 0.5, filterEnvAmount: 0.4, filterLfoOn: false, filterKeyFollow: 0.5,
        attack: 0.01, decay: 0.3, sustain: 0.5, release: 0.4,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 3.5, lfoDepth: 0.2, lfoToPitchOn: false,
        arpMode: .random, arpOctaves: 3, arpHold: true, arpRate: 9.5,
        benderVcoSens: 3, benderVcfSens: 1, portamentoTime: 0.05, portamentoOn: false,
        echoVolume: 0.4, echoTime: 0.35, echoRepeat: 0.4,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let chromeVapor = SynthPreset(
        id: UUID(uuidString: "BEC12BDC-47C7-4B3B-86E4-B6E7B1FB1D1E")!,
        name: "Chrome Vapor", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 7.3, vcoPulseWidth: 0.3, vcoPwmSource: .manual,
        mixSawLevel: 0.8, mixPulseLevel: 0.65, mixSubLevel: 0.1, mixNoiseLevel: 0.05, mixSubMode: .minus2Square,
        filterCutoff: 3600, filterResonance: 0.5, filterEnvAmount: 0.55, filterLfoOn: false, filterKeyFollow: 0.45,
        attack: 0.006, decay: 0.4, sustain: 0.65, release: 0.5,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 5.5, lfoDepth: 0.15, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 5, benderVcfSens: 2, portamentoTime: 0.1, portamentoOn: false,
        echoVolume: 0.25, echoTime: 0.3, echoRepeat: 0.28,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let slowTide = SynthPreset(
        id: UUID(uuidString: "5C718BBD-7061-4EF8-BA7C-C29A96092254")!,
        name: "Slow Tide", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0.9, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.5, mixPulseLevel: 0.45, mixSubLevel: 0.5, mixNoiseLevel: 0.1, mixSubMode: .minus1Square,
        filterCutoff: 900, filterResonance: 0.2, filterEnvAmount: 0.3, filterLfoOn: true, filterKeyFollow: 0.3,
        attack: 2.6, decay: 1.6, sustain: 0.85, release: 3.6,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.15, lfoDepth: 0.45, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 1.5, portamentoOn: true,
        echoVolume: 0.45, echoTime: 2.4, echoRepeat: 0.55,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let ashField = SynthPreset(
        id: UUID(uuidString: "2230B95B-074F-4761-B9FF-F8D33B0AD5AE")!,
        name: "Ash Field", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -3.5, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.2, mixPulseLevel: 0.15, mixSubLevel: 0.55, mixNoiseLevel: 0.6, mixSubMode: .minus2Square,
        filterCutoff: 350, filterResonance: 0.4, filterEnvAmount: 0.15, filterLfoOn: true, filterKeyFollow: 0.15,
        attack: 3.0, decay: 1.8, sustain: 0.7, release: 4.0,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 0.6, lfoDepth: 0.35, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.4, portamentoTime: 1.8, portamentoOn: true,
        echoVolume: 0.4, echoTime: 2.8, echoRepeat: 0.5,
        limiterThreshold: -5, limiterCeiling: 0
    )

    static let neonHallway = SynthPreset(
        id: UUID(uuidString: "5D20BB8B-8862-4D24-838D-F65FF7136141")!,
        name: "Neon Hallway", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 5.5, vcoPulseWidth: 0.4, vcoPwmSource: .env,
        mixSawLevel: 0.1, mixPulseLevel: 0.2, mixSubLevel: 0.1, mixNoiseLevel: 0.6, mixSubMode: .minus2Pulse,
        filterCutoff: 90, filterResonance: 0.75, filterEnvAmount: 0.5, filterLfoOn: true, filterKeyFollow: 0.85,
        attack: 0.008, decay: 2.6, sustain: 0.75, release: 0.12,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 2.2, lfoDepth: 0.4, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 1, arpHold: true, arpRate: 5.8,
        benderVcoSens: 5, benderVcfSens: 0.7, portamentoTime: 0.03, portamentoOn: false,
        echoVolume: 0.75, echoTime: 0.5, echoRepeat: 0.65,
        limiterThreshold: -10, limiterCeiling: 0
    )

    static let frostBloom = SynthPreset(
        id: UUID(uuidString: "0E491311-19DB-4A0F-9572-B02B96F20D58")!,
        name: "Frost Bloom", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 1.2, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.45, mixPulseLevel: 0.7, mixSubLevel: 0.05, mixNoiseLevel: 0, mixSubMode: .minus2Pulse,
        filterCutoff: 4800, filterResonance: 0.3, filterEnvAmount: 0.7, filterLfoOn: false, filterKeyFollow: 0.8,
        attack: 0.003, decay: 1.6, sustain: 0.1, release: 1.4,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 4.0, lfoDepth: 0.05, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.02, portamentoOn: false,
        echoVolume: 0.42, echoTime: 0.48, echoRepeat: 0.4,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let distantSignal = SynthPreset(
        id: UUID(uuidString: "A4FD862A-BC07-453D-A937-450E8818CC83")!,
        name: "Distant Signal", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -6.2, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0, mixPulseLevel: 0.15, mixSubLevel: 0.25, mixNoiseLevel: 0.7, mixSubMode: .minus2Pulse,
        filterCutoff: 1100, filterResonance: 0.6, filterEnvAmount: 0.35, filterLfoOn: true, filterKeyFollow: 0.5,
        attack: 0.5, decay: 0.4, sustain: 0.2, release: 1.2,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 1.4, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 2, arpHold: true, arpRate: 3.2,
        benderVcoSens: 2, benderVcfSens: 0.8, portamentoTime: 0.4, portamentoOn: false,
        echoVolume: 0.6, echoTime: 1.6, echoRepeat: 0.55,
        limiterThreshold: -6, limiterCeiling: 0
    )

    static let copperRain = SynthPreset(
        id: UUID(uuidString: "4E478681-213B-42C4-9059-BBFC5C7AEE26")!,
        name: "Copper Rain", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 4.0, vcoPulseWidth: 0.35, vcoPwmSource: .manual,
        mixSawLevel: 0.7, mixPulseLevel: 0.5, mixSubLevel: 0.05, mixNoiseLevel: 0.1, mixSubMode: .minus2Square,
        filterCutoff: 3200, filterResonance: 0.35, filterEnvAmount: 0.45, filterLfoOn: false, filterKeyFollow: 0.5,
        attack: 0.004, decay: 0.3, sustain: 0.2, release: 0.35,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 6.0, lfoDepth: 0.1, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 2, arpHold: false, arpRate: 10.5,
        benderVcoSens: 3, benderVcfSens: 1.2, portamentoTime: 0.08, portamentoOn: false,
        echoVolume: 0.35, echoTime: 0.28, echoRepeat: 0.32,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let sunkenBell = SynthPreset(
        id: UUID(uuidString: "86675745-131D-4697-B539-19B4E115C399")!,
        name: "Sunken Bell", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -0.8, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.3, mixPulseLevel: 0.55, mixSubLevel: 0.35, mixNoiseLevel: 0.05, mixSubMode: .minus1Square,
        filterCutoff: 1600, filterResonance: 0.4, filterEnvAmount: 0.6, filterLfoOn: false, filterKeyFollow: 0.6,
        attack: 0.005, decay: 2.4, sustain: 0.15, release: 2.8,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 1.8, lfoDepth: 0.1, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.05, portamentoOn: false,
        echoVolume: 0.55, echoTime: 1.9, echoRepeat: 0.6,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let gravelRoad = SynthPreset(
        id: UUID(uuidString: "289FB5FD-B05D-4444-AEC4-DC26F405B07E")!,
        name: "Gravel Road", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.2, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.4, mixPulseLevel: 0.6, mixSubLevel: 0.6, mixNoiseLevel: 0.2, mixSubMode: .minus2Square,
        filterCutoff: 220, filterResonance: 0.45, filterEnvAmount: -0.2, filterLfoOn: false, filterKeyFollow: 0.6,
        attack: 0.005, decay: 0.18, sustain: 0.55, release: 0.3,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 4.5, lfoDepth: 0.15, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.12, portamentoOn: false,
        echoVolume: 0.15, echoTime: 0.22, echoRepeat: 0.2,
        limiterThreshold: -2, limiterCeiling: -1
    )

    static let staticBloom = SynthPreset(
        id: UUID(uuidString: "236E22D4-5667-475C-A2EB-F446DA88E7B5")!,
        name: "Static Bloom", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 2.8, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.15, mixPulseLevel: 0.1, mixSubLevel: 0.2, mixNoiseLevel: 0.85, mixSubMode: .minus2Pulse,
        filterCutoff: 600, filterResonance: 0.55, filterEnvAmount: 0.5, filterLfoOn: true, filterKeyFollow: 0.2,
        attack: 1.4, decay: 0.8, sustain: 0.6, release: 2.2,
        vcaMode: .env,
        lfoWaveform: .noise, lfoRate: 0.9, lfoDepth: 0.55, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.6, portamentoTime: 0.5, portamentoOn: false,
        echoVolume: 0.5, echoTime: 1.1, echoRepeat: 0.5,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let lastTram = SynthPreset(
        id: UUID(uuidString: "37674A6A-2F31-4969-932F-75789259F619")!,
        name: "Last Tram", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -2.6, vcoPulseWidth: 0.45, vcoPwmSource: .lfo,
        mixSawLevel: 0.4, mixPulseLevel: 0.35, mixSubLevel: 0.55, mixNoiseLevel: 0.15, mixSubMode: .minus2Square,
        filterCutoff: 560, filterResonance: 0.3, filterEnvAmount: 0.3, filterLfoOn: true, filterKeyFollow: 0.3,
        attack: 1.0, decay: 0.7, sustain: 0.7, release: 2.5,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.4, lfoDepth: 0.4, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 2, arpHold: true, arpRate: 2.8,
        benderVcoSens: 2.5, benderVcfSens: 0.7, portamentoTime: 0.7, portamentoOn: false,
        echoVolume: 0.6, echoTime: 2.0, echoRepeat: 0.6,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let paleHorizon = SynthPreset(
        id: UUID(uuidString: "BF54186C-B600-40A5-B8F5-AACB40C4D163")!,
        name: "Pale Horizon", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0.5, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.5, mixPulseLevel: 0.4, mixSubLevel: 0.45, mixNoiseLevel: 0.05, mixSubMode: .minus1Square,
        filterCutoff: 1800, filterResonance: 0.2, filterEnvAmount: 0.25, filterLfoOn: false, filterKeyFollow: 0.35,
        attack: 2.0, decay: 1.3, sustain: 0.8, release: 3.0,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.22, lfoDepth: 0.3, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 1.0, portamentoOn: true,
        echoVolume: 0.4, echoTime: 1.5, echoRepeat: 0.45,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let wireFence = SynthPreset(
        id: UUID(uuidString: "8F137EDD-F014-4459-B635-EC445427500C")!,
        name: "Wire Fence", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 9.5, vcoPulseWidth: 0.2, vcoPwmSource: .manual,
        mixSawLevel: 0.6, mixPulseLevel: 0.75, mixSubLevel: 0, mixNoiseLevel: 0.2, mixSubMode: .minus2Pulse,
        filterCutoff: 2400, filterResonance: 0.6, filterEnvAmount: 0.4, filterLfoOn: false, filterKeyFollow: 0.4,
        attack: 0.003, decay: 0.2, sustain: 0.1, release: 0.25,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 9.0, lfoDepth: 0.2, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 4, benderVcfSens: 1.5, portamentoTime: 0.05, portamentoOn: false,
        echoVolume: 0.25, echoTime: 0.2, echoRepeat: 0.22,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let kelpForest = SynthPreset(
        id: UUID(uuidString: "C598A398-DB6E-422F-91C9-C1529A7F6206")!,
        name: "Kelp Forest", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.3, vcoPulseWidth: 0.5, vcoPwmSource: .env,
        mixSawLevel: 0.3, mixPulseLevel: 0.25, mixSubLevel: 0.85, mixNoiseLevel: 0.15, mixSubMode: .minus1Square,
        filterCutoff: 260, filterResonance: 0.35, filterEnvAmount: 0.2, filterLfoOn: true, filterKeyFollow: 0.2,
        attack: 2.8, decay: 1.4, sustain: 0.9, release: 4.2,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.16, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.4, portamentoTime: 2.0, portamentoOn: true,
        echoVolume: 0.5, echoTime: 3.0, echoRepeat: 0.65,
        limiterThreshold: -5, limiterCeiling: 0
    )

    static let fadedPolaroid = SynthPreset(
        id: UUID(uuidString: "F15C9D10-28CD-449A-BB67-5110A69FB0B7")!,
        name: "Faded Polaroid", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -0.4, vcoPulseWidth: 0.55, vcoPwmSource: .manual,
        mixSawLevel: 0.55, mixPulseLevel: 0.35, mixSubLevel: 0.4, mixNoiseLevel: 0.08, mixSubMode: .minus1Square,
        filterCutoff: 1200, filterResonance: 0.25, filterEnvAmount: 0.2, filterLfoOn: false, filterKeyFollow: 0.3,
        attack: 1.5, decay: 1.0, sustain: 0.75, release: 2.2,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.3, lfoDepth: 0.25, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.6, portamentoOn: true,
        echoVolume: 0.35, echoTime: 1.0, echoRepeat: 0.4,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let steelDrizzle = SynthPreset(
        id: UUID(uuidString: "E8A769FA-D178-4BC2-A447-BEF7C7B95EF1")!,
        name: "Steel Drizzle", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 3.3, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.2, mixPulseLevel: 0.3, mixSubLevel: 0.1, mixNoiseLevel: 0.65, mixSubMode: .minus2Square,
        filterCutoff: 5200, filterResonance: 0.5, filterEnvAmount: 0.35, filterLfoOn: true, filterKeyFollow: 0.4,
        attack: 0.6, decay: 0.5, sustain: 0.3, release: 1.5,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 6.5, lfoDepth: 0.4, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 1, portamentoTime: 0.25, portamentoOn: false,
        echoVolume: 0.4, echoTime: 0.7, echoRepeat: 0.45,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let lowTideBass = SynthPreset(
        id: UUID(uuidString: "7D8DC053-7327-442E-8C83-803609755E6E")!,
        name: "Low Tide Bass", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.15, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.2, mixPulseLevel: 0.45, mixSubLevel: 0.8, mixNoiseLevel: 0.05, mixSubMode: .minus1Square,
        filterCutoff: 160, filterResonance: 0.5, filterEnvAmount: -0.25, filterLfoOn: false, filterKeyFollow: 0.65,
        attack: 0.004, decay: 0.2, sustain: 0.6, release: 0.4,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 1.0, lfoDepth: 0.15, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0, portamentoTime: 0.18, portamentoOn: false,
        echoVolume: 0.12, echoTime: 0.25, echoRepeat: 0.18,
        limiterThreshold: -2, limiterCeiling: -1
    )

    static let paperLantern = SynthPreset(
        id: UUID(uuidString: "51C1963E-FDB7-4F38-9A61-96B3381A48B6")!,
        name: "Paper Lantern", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 0.7, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.4, mixPulseLevel: 0.5, mixSubLevel: 0.15, mixNoiseLevel: 0.1, mixSubMode: .minus2Pulse,
        filterCutoff: 2200, filterResonance: 0.25, filterEnvAmount: 0.4, filterLfoOn: false, filterKeyFollow: 0.5,
        attack: 0.02, decay: 1.0, sustain: 0.3, release: 1.2,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.5, lfoDepth: 0.1, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.4, portamentoTime: 0.1, portamentoOn: false,
        echoVolume: 0.4, echoTime: 0.55, echoRepeat: 0.42,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let marshLight = SynthPreset(
        id: UUID(uuidString: "9E759150-F6DB-4F6E-AEC8-6CA1216A710C")!,
        name: "Marsh Light", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -1.6, vcoPulseWidth: 0.6, vcoPwmSource: .lfo,
        mixSawLevel: 0.35, mixPulseLevel: 0.3, mixSubLevel: 0.6, mixNoiseLevel: 0.25, mixSubMode: .minus2Square,
        filterCutoff: 400, filterResonance: 0.4, filterEnvAmount: 0.3, filterLfoOn: true, filterKeyFollow: 0.25,
        attack: 2.4, decay: 1.6, sustain: 0.75, release: 3.5,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 0.3, lfoDepth: 0.4, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.6, portamentoTime: 1.3, portamentoOn: true,
        echoVolume: 0.5, echoTime: 2.2, echoRepeat: 0.55,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let dieselHum = SynthPreset(
        id: UUID(uuidString: "FF01438E-BDE6-4C9A-B618-95CA334CCF50")!,
        name: "Diesel Hum", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.1, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.5, mixPulseLevel: 0.55, mixSubLevel: 0.7, mixNoiseLevel: 0.3, mixSubMode: .minus2Square,
        filterCutoff: 180, filterResonance: 0.55, filterEnvAmount: 0.1, filterLfoOn: true, filterKeyFollow: 0.3,
        attack: 1.8, decay: 1.0, sustain: 0.9, release: 2.0,
        vcaMode: .gate,
        lfoWaveform: .square, lfoRate: 8.0, lfoDepth: 0.2, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.5, portamentoTime: 0.5, portamentoOn: false,
        echoVolume: 0.3, echoTime: 0.6, echoRepeat: 0.35,
        limiterThreshold: -6, limiterCeiling: 0
    )

    static let velvetFog = SynthPreset(
        id: UUID(uuidString: "C1881897-A688-4768-A13D-45597DA6373E")!,
        name: "Velvet Fog", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 0.2, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.45, mixPulseLevel: 0.4, mixSubLevel: 0.5, mixNoiseLevel: 0.03, mixSubMode: .minus1Square,
        filterCutoff: 1000, filterResonance: 0.18, filterEnvAmount: 0.15, filterLfoOn: false, filterKeyFollow: 0.3,
        attack: 2.2, decay: 1.2, sustain: 0.85, release: 3.2,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.25, lfoDepth: 0.2, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2, benderVcfSens: 0.4, portamentoTime: 1.4, portamentoOn: true,
        echoVolume: 0.45, echoTime: 1.8, echoRepeat: 0.5,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let boneDust = SynthPreset(
        id: UUID(uuidString: "F1CF6D83-4B2C-49A8-ABC1-F549B9998F36")!,
        name: "Bone Dust", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -4.5, vcoPulseWidth: 0.5, vcoPwmSource: .manual,
        mixSawLevel: 0.05, mixPulseLevel: 0.1, mixSubLevel: 0.15, mixNoiseLevel: 0.8, mixSubMode: .minus2Pulse,
        filterCutoff: 2600, filterResonance: 0.45, filterEnvAmount: 0.3, filterLfoOn: true, filterKeyFollow: 0.3,
        attack: 0.9, decay: 0.7, sustain: 0.2, release: 1.6,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 2.0, lfoDepth: 0.5, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5, benderVcfSens: 0.5, portamentoTime: 0.4, portamentoOn: false,
        echoVolume: 0.4, echoTime: 1.2, echoRepeat: 0.45,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let wanderingStar = SynthPreset(
        id: UUID(uuidString: "6E2C6073-00B4-4F57-8ECC-C533E1CC5416")!,
        name: "Wandering Star", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 1.5, vcoPulseWidth: 0.5, vcoPwmSource: .lfo,
        mixSawLevel: 0.4, mixPulseLevel: 0.45, mixSubLevel: 0.3, mixNoiseLevel: 0.1, mixSubMode: .minus1Square,
        filterCutoff: 1800, filterResonance: 0.3, filterEnvAmount: 0.3, filterLfoOn: false, filterKeyFollow: 0.4,
        attack: 0.02, decay: 0.5, sustain: 0.55, release: 0.9,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.5, lfoDepth: 0.3, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 3, arpHold: true, arpRate: 4.0,
        benderVcoSens: 2, benderVcfSens: 0.6, portamentoTime: 0.2, portamentoOn: false,
        echoVolume: 0.45, echoTime: 1.5, echoRepeat: 0.5,
        limiterThreshold: -4, limiterCeiling: 0
    )

    static let crackedMirror = SynthPreset(
        id: UUID(uuidString: "3B3B7BBC-5E0D-40F1-BA14-118A28B78558")!,
        name: "Cracked Mirror", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 6.6, vcoPulseWidth: 0.15, vcoPwmSource: .manual,
        mixSawLevel: 0.75, mixPulseLevel: 0.6, mixSubLevel: 0.05, mixNoiseLevel: 0.25, mixSubMode: .minus2Pulse,
        filterCutoff: 4400, filterResonance: 0.8, filterEnvAmount: 0.6, filterLfoOn: false, filterKeyFollow: 0.5,
        attack: 0.004, decay: 0.25, sustain: 0.3, release: 0.3,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 13.0, lfoDepth: 0.15, lfoToPitchOn: true,
        arpMode: .random, arpOctaves: 2, arpHold: false, arpRate: 12.0,
        benderVcoSens: 5, benderVcfSens: 2.5, portamentoTime: 0.03, portamentoOn: false,
        echoVolume: 0.3, echoTime: 0.3, echoRepeat: 0.32,
        limiterThreshold: -3, limiterCeiling: 0
    )
}
