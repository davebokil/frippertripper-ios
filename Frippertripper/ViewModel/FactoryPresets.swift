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
        ravineSump, encrustedDune, overcastSnowdrift, driftingMeadow, hiddenFog, crackedWail, peatPylon, hiddenPulse,
        ashRelay, bluffCoolant, crumblingKeys, brambleCircuit, saltWornFrost, threadbareCliff, deltaVoltage, prairiePylon,
        crackedEmber, hollowCable, ashRatchet, coralStatic, kelpPiston, waningDelta, ashFlange, crumblingDune,
        floeBeacon, shaleRivet, moraineAlloy, kelpSignal, shutteredGrove, fjordRelay, moltenReef, glacierBallast,
        driftingShale, frostAlloy, driftingSnowdrift, cliffRatchet, buriedReef, mistFilament, waningDriftwood, prairieCoolant,
        hollowDriftwood, mutedAsh, silentMoraine, groveCircuit, waningBackwater, overcastMoraine, waningHeath, kelpAntenna,
        prairieSignal, glacierSolder,
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

    static let ravineSump = SynthPreset(
        id: UUID(uuidString: "D37F3A97-7398-4A5D-89DA-01C877C181E0")!,
        name: "Ravine Sump", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 1.7239, vcoPulseWidth: 0.5993, vcoPwmSource: .manual,
        mixSawLevel: 0.5911, mixPulseLevel: 0.5276, mixSubLevel: 0.4536, mixNoiseLevel: 0.004, mixSubMode: .minus2Square,
        filterCutoff: 2507.9035, filterResonance: 0.314, filterEnvAmount: 0.2925, filterLfoOn: true, filterKeyFollow: 0.3407,
        attack: 2.8105, decay: 1.5046, sustain: 0.8279, release: 2.578,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.196, lfoDepth: 0.4157, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.6576, benderVcfSens: 0.5528, portamentoTime: 1.4828, portamentoOn: true,
        echoVolume: 0.4238, echoTime: 2.2815, echoRepeat: 0.4971,
        limiterThreshold: -4.3244, limiterCeiling: 0
    )

    static let encrustedDune = SynthPreset(
        id: UUID(uuidString: "40595570-36CB-4D1B-ABB5-E5642CA24BE8")!,
        name: "Encrusted Dune", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.6704, vcoPulseWidth: 0.4886, vcoPwmSource: .manual,
        mixSawLevel: 0.1832, mixPulseLevel: 0.558, mixSubLevel: 0.8388, mixNoiseLevel: 0.0016, mixSubMode: .minus2Square,
        filterCutoff: 236.2432, filterResonance: 0.4737, filterEnvAmount: -0.2032, filterLfoOn: false, filterKeyFollow: 0.5304,
        attack: 0.0174, decay: 0.2195, sustain: 0.6888, release: 0.3676,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 4.3855, lfoDepth: 0.2607, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.8861, benderVcfSens: 0.019, portamentoTime: 0.074, portamentoOn: false,
        echoVolume: 0.1955, echoTime: 0.3393, echoRepeat: 0.1985,
        limiterThreshold: -1.8995, limiterCeiling: -0.3266
    )

    static let overcastSnowdrift = SynthPreset(
        id: UUID(uuidString: "16CC2466-1EE7-4879-8201-F0959C68C48B")!,
        name: "Overcast Snowdrift", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 5.6549, vcoPulseWidth: 0.2662, vcoPwmSource: .env,
        mixSawLevel: 0.7717, mixPulseLevel: 0.5076, mixSubLevel: 0.1272, mixNoiseLevel: 0.0475, mixSubMode: .minus2Square,
        filterCutoff: 2622.8853, filterResonance: 0.474, filterEnvAmount: 0.3992, filterLfoOn: false, filterKeyFollow: 0.4216,
        attack: 0.013, decay: 0.289, sustain: 0.5801, release: 0.3939,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 9.8406, lfoDepth: 0.2142, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 3.7314, benderVcfSens: 2.5103, portamentoTime: 0.1115, portamentoOn: false,
        echoVolume: 0.2448, echoTime: 0.3479, echoRepeat: 0.297,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let driftingMeadow = SynthPreset(
        id: UUID(uuidString: "9B1007DF-107F-4452-A7FC-0B66F9CC21D1")!,
        name: "Drifting Meadow", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.7968, vcoPulseWidth: 0.5441, vcoPwmSource: .manual,
        mixSawLevel: 0.4505, mixPulseLevel: 0.2534, mixSubLevel: 0.8699, mixNoiseLevel: 0.1907, mixSubMode: .minus1Square,
        filterCutoff: 109.0057, filterResonance: 0.4151, filterEnvAmount: 0.1146, filterLfoOn: true, filterKeyFollow: 0.2055,
        attack: 4.0453, decay: 1.7811, sustain: 0.9489, release: 3.5498,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.2377, lfoDepth: 0.4623, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.7998, benderVcfSens: 0.2285, portamentoTime: 2.3309, portamentoOn: true,
        echoVolume: 0.5623, echoTime: 3.3132, echoRepeat: 0.6571,
        limiterThreshold: -5.8002, limiterCeiling: 0
    )

    static let hiddenFog = SynthPreset(
        id: UUID(uuidString: "9CBDE86A-B415-467C-9A24-A65575639F04")!,
        name: "Hidden Fog", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 0.9595, vcoPulseWidth: 0.5072, vcoPwmSource: .manual,
        mixSawLevel: 0.3998, mixPulseLevel: 0.5772, mixSubLevel: 0.064, mixNoiseLevel: 0.0467, mixSubMode: .minus2Pulse,
        filterCutoff: 5548.3096, filterResonance: 0.2545, filterEnvAmount: 0.7085, filterLfoOn: false, filterKeyFollow: 0.8455,
        attack: 0.0056, decay: 1.5848, sustain: 0.0651, release: 1.8611,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.2241, lfoDepth: 0.0814, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.2761, benderVcfSens: 0.5302, portamentoTime: 0.0435, portamentoOn: false,
        echoVolume: 0.4088, echoTime: 0.5901, echoRepeat: 0.3481,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let crackedWail = SynthPreset(
        id: UUID(uuidString: "0C73E1D0-CF1A-45B1-B4AE-321FC21BD4A0")!,
        name: "Cracked Wail", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 1.947, vcoPulseWidth: 0.3834, vcoPwmSource: .env,
        mixSawLevel: 0.135, mixPulseLevel: 0.1625, mixSubLevel: 0.1963, mixNoiseLevel: 0.6534, mixSubMode: .minus2Pulse,
        filterCutoff: 895.9172, filterResonance: 0.8233, filterEnvAmount: 0.5663, filterLfoOn: true, filterKeyFollow: 0.7146,
        attack: 0.0072, decay: 2.0876, sustain: 0.8546, release: 0.1588,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 1.8033, lfoDepth: 0.4973, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 1, arpHold: true, arpRate: 5.8206,
        benderVcoSens: 5.8913, benderVcfSens: 0.9325, portamentoTime: 0.0414, portamentoOn: false,
        echoVolume: 0.7025, echoTime: 0.5532, echoRepeat: 0.5853,
        limiterThreshold: -8.1893, limiterCeiling: 0
    )

    static let peatPylon = SynthPreset(
        id: UUID(uuidString: "0033874E-246E-4C8B-9F34-4638B9180D15")!,
        name: "Peat Pylon", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 6.4032, vcoPulseWidth: 0.5264, vcoPwmSource: .manual,
        mixSawLevel: 0.7297, mixPulseLevel: 0.5407, mixSubLevel: 0.0844, mixNoiseLevel: 0.11, mixSubMode: .minus2Square,
        filterCutoff: 2003.9205, filterResonance: 0.3343, filterEnvAmount: 0.3889, filterLfoOn: false, filterKeyFollow: 0.4087,
        attack: 0.0163, decay: 0.2075, sustain: 0.424, release: 0.4757,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 8.7114, lfoDepth: 0.1151, lfoToPitchOn: false,
        arpMode: .random, arpOctaves: 3, arpHold: true, arpRate: 7.3854,
        benderVcoSens: 3.5013, benderVcfSens: 0.7417, portamentoTime: 0.0648, portamentoOn: false,
        echoVolume: 0.4099, echoTime: 0.4274, echoRepeat: 0.4456,
        limiterThreshold: -3.9177, limiterCeiling: 0
    )

    static let hiddenPulse = SynthPreset(
        id: UUID(uuidString: "D5E9BF9B-5652-46D5-8435-1C9AFDA16405")!,
        name: "Hidden Pulse", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -2.4068, vcoPulseWidth: 0.5155, vcoPwmSource: .manual,
        mixSawLevel: 0.2511, mixPulseLevel: 0.1401, mixSubLevel: 0.154, mixNoiseLevel: 0.6425, mixSubMode: .minus2Pulse,
        filterCutoff: 2103.0519, filterResonance: 0.4418, filterEnvAmount: 0.2823, filterLfoOn: true, filterKeyFollow: 0.3682,
        attack: 0.7462, decay: 0.7861, sustain: 0.259, release: 2.17,
        vcaMode: .env,
        lfoWaveform: .noise, lfoRate: 4.0176, lfoDepth: 0.4738, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.1171, benderVcfSens: 0.7492, portamentoTime: 0.3161, portamentoOn: false,
        echoVolume: 0.303, echoTime: 0.8016, echoRepeat: 0.3222,
        limiterThreshold: -4.6957, limiterCeiling: 0
    )

    static let ashRelay = SynthPreset(
        id: UUID(uuidString: "E4E21627-92DD-4D45-A590-AB8D948873CE")!,
        name: "Ash Relay", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -1.1443, vcoPulseWidth: 0.4498, vcoPwmSource: .manual,
        mixSawLevel: 0.4959, mixPulseLevel: 0.3284, mixSubLevel: 0.2475, mixNoiseLevel: 0.1169, mixSubMode: .minus1Square,
        filterCutoff: 2325.9763, filterResonance: 0.3277, filterEnvAmount: 0.2088, filterLfoOn: true, filterKeyFollow: 0.3274,
        attack: 2.8598, decay: 1.0732, sustain: 0.7974, release: 3.6751,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.3269, lfoDepth: 0.3602, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.2579, benderVcfSens: 0.5479, portamentoTime: 1.5863, portamentoOn: true,
        echoVolume: 0.4377, echoTime: 1.9994, echoRepeat: 0.585,
        limiterThreshold: -3.0334, limiterCeiling: 0
    )

    static let bluffCoolant = SynthPreset(
        id: UUID(uuidString: "B6F3698D-E7A9-4ECE-903C-C095100661FC")!,
        name: "Bluff Coolant", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.5834, vcoPulseWidth: 0.465, vcoPwmSource: .manual,
        mixSawLevel: 0.2496, mixPulseLevel: 0.539, mixSubLevel: 0.6141, mixNoiseLevel: 0.0913, mixSubMode: .minus1Square,
        filterCutoff: 195.8712, filterResonance: 0.4765, filterEnvAmount: -0.0769, filterLfoOn: false, filterKeyFollow: 0.796,
        attack: 0.0145, decay: 0.2921, sustain: 0.457, release: 0.4582,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.5167, lfoDepth: 0.1304, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.0941, benderVcfSens: 0.0672, portamentoTime: 0.1629, portamentoOn: false,
        echoVolume: 0.1615, echoTime: 0.3145, echoRepeat: 0.1877,
        limiterThreshold: -2.9605, limiterCeiling: -0.5826
    )

    static let crumblingKeys = SynthPreset(
        id: UUID(uuidString: "2741EF66-3F61-4AD7-BDA4-39731992EB0C")!,
        name: "Crumbling Keys", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 6.6458, vcoPulseWidth: 0.1808, vcoPwmSource: .env,
        mixSawLevel: 0.6882, mixPulseLevel: 0.5441, mixSubLevel: 0.0566, mixNoiseLevel: 0.1412, mixSubMode: .minus2Pulse,
        filterCutoff: 2384.2398, filterResonance: 0.4472, filterEnvAmount: 0.6384, filterLfoOn: false, filterKeyFollow: 0.3719,
        attack: 0.0162, decay: 0.2057, sustain: 0.5248, release: 0.5233,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 12.1476, lfoDepth: 0.1401, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 4.8389, benderVcfSens: 2.4845, portamentoTime: 0.0906, portamentoOn: false,
        echoVolume: 0.3305, echoTime: 0.2588, echoRepeat: 0.2445,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let brambleCircuit = SynthPreset(
        id: UUID(uuidString: "3695745F-F16D-49D9-9477-4E3E1E9C1B0A")!,
        name: "Bramble Circuit", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.6427, vcoPulseWidth: 0.5095, vcoPwmSource: .manual,
        mixSawLevel: 0.303, mixPulseLevel: 0.288, mixSubLevel: 0.9088, mixNoiseLevel: 0.1035, mixSubMode: .minus1Square,
        filterCutoff: 231.2958, filterResonance: 0.2963, filterEnvAmount: 0.086, filterLfoOn: true, filterKeyFollow: 0.1502,
        attack: 3.6084, decay: 1.7299, sustain: 0.9647, release: 3.9767,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.1567, lfoDepth: 0.4528, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.7487, benderVcfSens: 0.325, portamentoTime: 1.747, portamentoOn: true,
        echoVolume: 0.5877, echoTime: 2.7168, echoRepeat: 0.5608,
        limiterThreshold: -4.2161, limiterCeiling: 0
    )

    static let saltWornFrost = SynthPreset(
        id: UUID(uuidString: "D36C4F21-6894-414C-868D-8EA2BBF5981A")!,
        name: "Salt-worn Frost", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -1.3872, vcoPulseWidth: 0.4834, vcoPwmSource: .manual,
        mixSawLevel: 0.5632, mixPulseLevel: 0.844, mixSubLevel: 0.0469, mixNoiseLevel: 0.0207, mixSubMode: .minus2Pulse,
        filterCutoff: 4285.0033, filterResonance: 0.3103, filterEnvAmount: 0.6081, filterLfoOn: false, filterKeyFollow: 0.8208,
        attack: 0.0023, decay: 1.4396, sustain: 0.066, release: 1.4521,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 2.1761, lfoDepth: 0.0763, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.0567, benderVcfSens: 0.4737, portamentoTime: 0.0297, portamentoOn: false,
        echoVolume: 0.4329, echoTime: 0.4223, echoRepeat: 0.4079,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let threadbareCliff = SynthPreset(
        id: UUID(uuidString: "781DF118-91D6-4702-90C1-E4D69651F8D8")!,
        name: "Threadbare Cliff", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -0.7025, vcoPulseWidth: 0.4071, vcoPwmSource: .env,
        mixSawLevel: 0.0852, mixPulseLevel: 0.0752, mixSubLevel: 0.117, mixNoiseLevel: 0.8323, mixSubMode: .minus2Pulse,
        filterCutoff: 786.7554, filterResonance: 0.6893, filterEnvAmount: 0.6169, filterLfoOn: true, filterKeyFollow: 0.7031,
        attack: 0.0116, decay: 2.7573, sustain: 0.7668, release: 0.1394,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 3.2519, lfoDepth: 0.4889, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 1, arpHold: true, arpRate: 6.872,
        benderVcoSens: 6.1122, benderVcfSens: 0.7625, portamentoTime: 0.0433, portamentoOn: false,
        echoVolume: 0.6589, echoTime: 0.3883, echoRepeat: 0.7147,
        limiterThreshold: -8.6784, limiterCeiling: 0
    )

    static let deltaVoltage = SynthPreset(
        id: UUID(uuidString: "E09A2744-51CF-40FF-B5C6-F1FCBAA42B44")!,
        name: "Delta Voltage", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -0.1623, vcoPulseWidth: 0.3422, vcoPwmSource: .lfo,
        mixSawLevel: 0.4128, mixPulseLevel: 0.5807, mixSubLevel: 0.1557, mixNoiseLevel: 0.0935, mixSubMode: .minus1Square,
        filterCutoff: 2432.1336, filterResonance: 0.4026, filterEnvAmount: 0.3881, filterLfoOn: false, filterKeyFollow: 0.3609,
        attack: 0.0169, decay: 0.2326, sustain: 0.6232, release: 0.3458,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 4.3228, lfoDepth: 0.1494, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 2, arpHold: true, arpRate: 13.4785,
        benderVcoSens: 3.1417, benderVcfSens: 1.4745, portamentoTime: 0.0608, portamentoOn: false,
        echoVolume: 0.5337, echoTime: 0.4104, echoRepeat: 0.4268,
        limiterThreshold: -3.8656, limiterCeiling: 0
    )

    static let prairiePylon = SynthPreset(
        id: UUID(uuidString: "1552471C-110A-4CEF-B08F-1E19A0EDB9E4")!,
        name: "Prairie Pylon", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -1.1679, vcoPulseWidth: 0.5191, vcoPwmSource: .manual,
        mixSawLevel: 0.0041, mixPulseLevel: 0.0756, mixSubLevel: 0.0744, mixNoiseLevel: 0.8217, mixSubMode: .minus2Pulse,
        filterCutoff: 2519.3909, filterResonance: 0.52, filterEnvAmount: 0.39, filterLfoOn: false, filterKeyFollow: 0.3262,
        attack: 0.664, decay: 0.4001, sustain: 0.2825, release: 0.8487,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 1.5692, lfoDepth: 0.4439, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.618, benderVcfSens: 0.6972, portamentoTime: 0.2068, portamentoOn: false,
        echoVolume: 0.4667, echoTime: 0.4717, echoRepeat: 0.3783,
        limiterThreshold: -5.0469, limiterCeiling: 0
    )

    static let crackedEmber = SynthPreset(
        id: UUID(uuidString: "D025C3B2-4B87-4275-A96B-4D8B6EA7FC55")!,
        name: "Cracked Ember", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -1.5799, vcoPulseWidth: 0.5916, vcoPwmSource: .lfo,
        mixSawLevel: 0.3715, mixPulseLevel: 0.4741, mixSubLevel: 0.4654, mixNoiseLevel: 0.1366, mixSubMode: .minus2Pulse,
        filterCutoff: 1340.7886, filterResonance: 0.3287, filterEnvAmount: 0.1842, filterLfoOn: false, filterKeyFollow: 0.2658,
        attack: 3.0193, decay: 1.5369, sustain: 0.8536, release: 4.0237,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.301, lfoDepth: 0.4088, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.655, benderVcfSens: 0.6365, portamentoTime: 1.4121, portamentoOn: true,
        echoVolume: 0.5494, echoTime: 2.4664, echoRepeat: 0.4347,
        limiterThreshold: -3.8327, limiterCeiling: 0
    )

    static let hollowCable = SynthPreset(
        id: UUID(uuidString: "56580D2C-3E44-4913-A00E-101F4362CD82")!,
        name: "Hollow Cable", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.7563, vcoPulseWidth: 0.5156, vcoPwmSource: .manual,
        mixSawLevel: 0.2432, mixPulseLevel: 0.5938, mixSubLevel: 0.7733, mixNoiseLevel: 0.0598, mixSubMode: .minus1Square,
        filterCutoff: 237.4907, filterResonance: 0.4825, filterEnvAmount: -0.1827, filterLfoOn: false, filterKeyFollow: 0.6747,
        attack: 0.0194, decay: 0.1764, sustain: 0.7095, release: 0.4207,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 1.3959, lfoDepth: 0.1099, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.7961, benderVcfSens: 0.2286, portamentoTime: 0.0991, portamentoOn: false,
        echoVolume: 0.1954, echoTime: 0.3175, echoRepeat: 0.224,
        limiterThreshold: -2.8846, limiterCeiling: -0.5233
    )

    static let ashRatchet = SynthPreset(
        id: UUID(uuidString: "0FB3DF18-C450-49C4-A386-407FE861DE59")!,
        name: "Ash Ratchet", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 3.9828, vcoPulseWidth: 0.1548, vcoPwmSource: .manual,
        mixSawLevel: 0.6486, mixPulseLevel: 0.5687, mixSubLevel: 0.0951, mixNoiseLevel: 0.0808, mixSubMode: .minus2Pulse,
        filterCutoff: 2443.5625, filterResonance: 0.5858, filterEnvAmount: 0.4347, filterLfoOn: false, filterKeyFollow: 0.4551,
        attack: 0.0143, decay: 0.5637, sustain: 0.7143, release: 0.3238,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 7.2126, lfoDepth: 0.0957, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 3.2681, benderVcfSens: 2.6982, portamentoTime: 0.0983, portamentoOn: false,
        echoVolume: 0.2773, echoTime: 0.2149, echoRepeat: 0.3489,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let coralStatic = SynthPreset(
        id: UUID(uuidString: "AE2CEE4D-3C12-4BFF-8DBA-2E93E3A64533")!,
        name: "Coral Static", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.8148, vcoPulseWidth: 0.5396, vcoPwmSource: .manual,
        mixSawLevel: 0.4829, mixPulseLevel: 0.3632, mixSubLevel: 0.7324, mixNoiseLevel: 0.0935, mixSubMode: .minus1Square,
        filterCutoff: 180.7801, filterResonance: 0.314, filterEnvAmount: 0.1713, filterLfoOn: true, filterKeyFollow: 0.1946,
        attack: 3.4813, decay: 1.3687, sustain: 0.8644, release: 3.7843,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.0921, lfoDepth: 0.4941, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.0134, benderVcfSens: 0.4471, portamentoTime: 2.1172, portamentoOn: true,
        echoVolume: 0.5954, echoTime: 2.7878, echoRepeat: 0.5915,
        limiterThreshold: -5.8224, limiterCeiling: 0
    )

    static let kelpPiston = SynthPreset(
        id: UUID(uuidString: "F44EDB1C-FE5A-419B-8A67-0E42AE871C64")!,
        name: "Kelp Piston", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -0.4696, vcoPulseWidth: 0.5183, vcoPwmSource: .manual,
        mixSawLevel: 0.4115, mixPulseLevel: 0.7096, mixSubLevel: 0.004, mixNoiseLevel: 0.0351, mixSubMode: .minus2Pulse,
        filterCutoff: 4245.0854, filterResonance: 0.4321, filterEnvAmount: 0.5969, filterLfoOn: false, filterKeyFollow: 0.7566,
        attack: 0.0041, decay: 2.0292, sustain: 0.0925, release: 1.4137,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.7903, lfoDepth: 0.0748, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.2601, benderVcfSens: 0.6356, portamentoTime: 0.0538, portamentoOn: false,
        echoVolume: 0.5416, echoTime: 0.5558, echoRepeat: 0.355,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let waningDelta = SynthPreset(
        id: UUID(uuidString: "DADB1FE5-16E7-4017-AB1C-227B1453BED2")!,
        name: "Waning Delta", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 0.4654, vcoPulseWidth: 0.3349, vcoPwmSource: .env,
        mixSawLevel: 0.0626, mixPulseLevel: 0.2099, mixSubLevel: 0.1573, mixNoiseLevel: 0.8045, mixSubMode: .minus2Pulse,
        filterCutoff: 815.5185, filterResonance: 0.7332, filterEnvAmount: 0.5265, filterLfoOn: true, filterKeyFollow: 0.7607,
        attack: 0.005, decay: 2.4793, sustain: 0.8627, release: 0.1491,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 2.6258, lfoDepth: 0.3308, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 1, arpHold: true, arpRate: 5.447,
        benderVcoSens: 6.6966, benderVcfSens: 0.7654, portamentoTime: 0.059, portamentoOn: false,
        echoVolume: 0.8881, echoTime: 0.3969, echoRepeat: 0.6578,
        limiterThreshold: -7.6192, limiterCeiling: 0
    )

    static let ashFlange = SynthPreset(
        id: UUID(uuidString: "EC009ED7-67BC-4BA4-96A1-4D4EBF850BDF")!,
        name: "Ash Flange", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 7.8323, vcoPulseWidth: 0.4762, vcoPwmSource: .lfo,
        mixSawLevel: 0.6606, mixPulseLevel: 0.5584, mixSubLevel: 0.0728, mixNoiseLevel: 0.0777, mixSubMode: .minus2Square,
        filterCutoff: 2189.2557, filterResonance: 0.3721, filterEnvAmount: 0.3988, filterLfoOn: false, filterKeyFollow: 0.3817,
        attack: 0.0181, decay: 0.1738, sustain: 0.5215, release: 0.3185,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 7.561, lfoDepth: 0.1003, lfoToPitchOn: false,
        arpMode: .random, arpOctaves: 3, arpHold: true, arpRate: 13.6542,
        benderVcoSens: 3.9415, benderVcfSens: 1.1523, portamentoTime: 0.0347, portamentoOn: false,
        echoVolume: 0.3597, echoTime: 0.3499, echoRepeat: 0.4789,
        limiterThreshold: -3.3256, limiterCeiling: 0
    )

    static let crumblingDune = SynthPreset(
        id: UUID(uuidString: "929E9E99-F2E9-4C35-9820-785BB5591A65")!,
        name: "Crumbling Dune", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 6.5341, vcoPulseWidth: 0.502, vcoPwmSource: .manual,
        mixSawLevel: 0.2666, mixPulseLevel: 0.1314, mixSubLevel: 0.0487, mixNoiseLevel: 0.72, mixSubMode: .minus2Pulse,
        filterCutoff: 4233.708, filterResonance: 0.3478, filterEnvAmount: 0.3966, filterLfoOn: true, filterKeyFollow: 0.4186,
        attack: 1.2156, decay: 0.7181, sustain: 0.396, release: 0.8232,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 3.1808, lfoDepth: 0.5651, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.88, benderVcfSens: 1.09, portamentoTime: 0.1548, portamentoOn: false,
        echoVolume: 0.4687, echoTime: 0.8792, echoRepeat: 0.4003,
        limiterThreshold: -3.9751, limiterCeiling: 0
    )

    static let floeBeacon = SynthPreset(
        id: UUID(uuidString: "719B24F3-DF7F-46C7-9C43-86600D2C951F")!,
        name: "Floe Beacon", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: 1.9955, vcoPulseWidth: 0.4851, vcoPwmSource: .lfo,
        mixSawLevel: 0.4862, mixPulseLevel: 0.3656, mixSubLevel: 0.2446, mixNoiseLevel: 0.138, mixSubMode: .minus2Square,
        filterCutoff: 1027.2541, filterResonance: 0.2493, filterEnvAmount: 0.1257, filterLfoOn: true, filterKeyFollow: 0.3479,
        attack: 2.4239, decay: 1.6471, sustain: 0.7413, release: 3.4688,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.1976, lfoDepth: 0.4918, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.8175, benderVcfSens: 0.6464, portamentoTime: 1.5476, portamentoOn: true,
        echoVolume: 0.5174, echoTime: 2.332, echoRepeat: 0.453,
        limiterThreshold: -4.1698, limiterCeiling: 0
    )

    static let shaleRivet = SynthPreset(
        id: UUID(uuidString: "BD8EA4FC-4DAB-48E3-A07B-6E0A91582173")!,
        name: "Shale Rivet", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.7219, vcoPulseWidth: 0.4803, vcoPwmSource: .manual,
        mixSawLevel: 0.235, mixPulseLevel: 0.3456, mixSubLevel: 0.6809, mixNoiseLevel: 0.0612, mixSubMode: .minus1Square,
        filterCutoff: 388.0672, filterResonance: 0.4073, filterEnvAmount: -0.0203, filterLfoOn: false, filterKeyFollow: 0.7483,
        attack: 0.0043, decay: 0.1519, sustain: 0.6561, release: 0.3002,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 1.3086, lfoDepth: 0.1063, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.7586, benderVcfSens: 0.11, portamentoTime: 0.0595, portamentoOn: false,
        echoVolume: 0.1707, echoTime: 0.2859, echoRepeat: 0.1593,
        limiterThreshold: -1.4462, limiterCeiling: -0.5004
    )

    static let moraineAlloy = SynthPreset(
        id: UUID(uuidString: "8E0A315C-53B8-4494-B7D0-4BB9F6B8241D")!,
        name: "Moraine Alloy", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 2.5382, vcoPulseWidth: 0.2259, vcoPwmSource: .env,
        mixSawLevel: 0.8262, mixPulseLevel: 0.5719, mixSubLevel: 0.0501, mixNoiseLevel: 0.092, mixSubMode: .minus1Square,
        filterCutoff: 3187.9239, filterResonance: 0.5993, filterEnvAmount: 0.5053, filterLfoOn: false, filterKeyFollow: 0.3529,
        attack: 0.005, decay: 0.5215, sustain: 0.562, release: 0.4991,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 5.4693, lfoDepth: 0.2045, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 4.6387, benderVcfSens: 1.4825, portamentoTime: 0.0852, portamentoOn: false,
        echoVolume: 0.2114, echoTime: 0.3672, echoRepeat: 0.3483,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let kelpSignal = SynthPreset(
        id: UUID(uuidString: "319963DE-EA33-4D96-8140-C0F149FC3F56")!,
        name: "Kelp Signal", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.2456, vcoPulseWidth: 0.4907, vcoPwmSource: .manual,
        mixSawLevel: 0.4443, mixPulseLevel: 0.3449, mixSubLevel: 0.892, mixNoiseLevel: 0.1394, mixSubMode: .minus1Square,
        filterCutoff: 282.0062, filterResonance: 0.279, filterEnvAmount: 0.1697, filterLfoOn: false, filterKeyFollow: 0.1779,
        attack: 3.4192, decay: 1.9929, sustain: 0.9732, release: 4.5509,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.1519, lfoDepth: 0.4552, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.3518, benderVcfSens: 0.3858, portamentoTime: 1.6768, portamentoOn: true,
        echoVolume: 0.5542, echoTime: 3.2273, echoRepeat: 0.6013,
        limiterThreshold: -5.5945, limiterCeiling: 0
    )

    static let shutteredGrove = SynthPreset(
        id: UUID(uuidString: "F90A2E4E-3BD0-4A31-BBBE-80E9DFBDDADC")!,
        name: "Shuttered Grove", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -1.1604, vcoPulseWidth: 0.4979, vcoPwmSource: .manual,
        mixSawLevel: 0.3961, mixPulseLevel: 0.6656, mixSubLevel: 0.0026, mixNoiseLevel: 0.0235, mixSubMode: .minus2Pulse,
        filterCutoff: 5081.927, filterResonance: 0.4121, filterEnvAmount: 0.6381, filterLfoOn: false, filterKeyFollow: 0.8015,
        attack: 0.0023, decay: 1.8869, sustain: 0.1387, release: 1.6782,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 2.1076, lfoDepth: 0.0484, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.1061, benderVcfSens: 0.601, portamentoTime: 0.0754, portamentoOn: false,
        echoVolume: 0.3847, echoTime: 0.4683, echoRepeat: 0.3321,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let fjordRelay = SynthPreset(
        id: UUID(uuidString: "B8089C1B-441B-40EB-A5F1-F31F52EBF848")!,
        name: "Fjord Relay", createdAt: referenceDate,
        vcoRange: .four, vcoTune: -0.7625, vcoPulseWidth: 0.4047, vcoPwmSource: .env,
        mixSawLevel: 0.1472, mixPulseLevel: 0.2406, mixSubLevel: 0.1755, mixNoiseLevel: 0.5817, mixSubMode: .minus2Pulse,
        filterCutoff: 836.483, filterResonance: 0.698, filterEnvAmount: 0.4061, filterLfoOn: true, filterKeyFollow: 0.8196,
        attack: 0.0093, decay: 2.919, sustain: 0.8006, release: 0.1715,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 3.0703, lfoDepth: 0.317, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: true, arpRate: 4.5988,
        benderVcoSens: 4.297, benderVcfSens: 0.5851, portamentoTime: 0.0292, portamentoOn: false,
        echoVolume: 0.6538, echoTime: 0.4551, echoRepeat: 0.6293,
        limiterThreshold: -10.5821, limiterCeiling: 0
    )

    static let moltenReef = SynthPreset(
        id: UUID(uuidString: "6D464E82-5AF0-47A0-89F0-1EED1D78E896")!,
        name: "Molten Reef", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 5.6619, vcoPulseWidth: 0.4152, vcoPwmSource: .lfo,
        mixSawLevel: 0.4717, mixPulseLevel: 0.4092, mixSubLevel: 0.2461, mixNoiseLevel: 0.0441, mixSubMode: .minus2Square,
        filterCutoff: 1396.5997, filterResonance: 0.4802, filterEnvAmount: 0.5534, filterLfoOn: false, filterKeyFollow: 0.3455,
        attack: 0.0074, decay: 0.3329, sustain: 0.6437, release: 0.2691,
        vcaMode: .env,
        lfoWaveform: .square, lfoRate: 3.0371, lfoDepth: 0.1016, lfoToPitchOn: false,
        arpMode: .up, arpOctaves: 2, arpHold: true, arpRate: 12.2557,
        benderVcoSens: 2.6401, benderVcfSens: 1.1706, portamentoTime: 0.0409, portamentoOn: false,
        echoVolume: 0.3601, echoTime: 0.3398, echoRepeat: 0.475,
        limiterThreshold: -3.8701, limiterCeiling: 0
    )

    static let glacierBallast = SynthPreset(
        id: UUID(uuidString: "3DE70DC9-E4D4-4B19-B046-6443A33087DA")!,
        name: "Glacier Ballast", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 6.0628, vcoPulseWidth: 0.3049, vcoPwmSource: .manual,
        mixSawLevel: 0.2031, mixPulseLevel: 0.1986, mixSubLevel: 0.0737, mixNoiseLevel: 0.8127, mixSubMode: .minus2Pulse,
        filterCutoff: 1856.5061, filterResonance: 0.3755, filterEnvAmount: 0.379, filterLfoOn: false, filterKeyFollow: 0.2163,
        attack: 0.7632, decay: 0.8792, sustain: 0.2394, release: 1.7415,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 3.65, lfoDepth: 0.439, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.9814, benderVcfSens: 1.164, portamentoTime: 0.4842, portamentoOn: false,
        echoVolume: 0.3395, echoTime: 0.5222, echoRepeat: 0.4531,
        limiterThreshold: -4.2519, limiterCeiling: 0
    )

    static let driftingShale = SynthPreset(
        id: UUID(uuidString: "070D41CB-025A-47F6-ADF4-B6C97631EECB")!,
        name: "Drifting Shale", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 1.7664, vcoPulseWidth: 0.4036, vcoPwmSource: .lfo,
        mixSawLevel: 0.4674, mixPulseLevel: 0.449, mixSubLevel: 0.4311, mixNoiseLevel: 0.1173, mixSubMode: .minus2Pulse,
        filterCutoff: 2547.4228, filterResonance: 0.1538, filterEnvAmount: 0.2735, filterLfoOn: false, filterKeyFollow: 0.2934,
        attack: 2.4797, decay: 0.842, sustain: 0.7689, release: 3.6853,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.2441, lfoDepth: 0.4005, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.2461, benderVcfSens: 0.5944, portamentoTime: 2.0781, portamentoOn: true,
        echoVolume: 0.3556, echoTime: 2.0861, echoRepeat: 0.5216,
        limiterThreshold: -3.7999, limiterCeiling: 0
    )

    static let frostAlloy = SynthPreset(
        id: UUID(uuidString: "9052FD60-0C15-44D1-902B-7D91EAAB86F5")!,
        name: "Frost Alloy", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.891, vcoPulseWidth: 0.5005, vcoPwmSource: .manual,
        mixSawLevel: 0.3752, mixPulseLevel: 0.3039, mixSubLevel: 0.8217, mixNoiseLevel: 0.1246, mixSubMode: .minus1Square,
        filterCutoff: 261.5415, filterResonance: 0.5124, filterEnvAmount: -0.1251, filterLfoOn: false, filterKeyFollow: 0.6045,
        attack: 0.016, decay: 0.2687, sustain: 0.7225, release: 0.2764,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 3.1368, lfoDepth: 0.2965, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5863, benderVcfSens: 0.0326, portamentoTime: 0.1989, portamentoOn: false,
        echoVolume: 0.0986, echoTime: 0.2794, echoRepeat: 0.2575,
        limiterThreshold: -1.0403, limiterCeiling: -0.1886
    )

    static let driftingSnowdrift = SynthPreset(
        id: UUID(uuidString: "FEC6BDBE-1292-45C5-AD0F-6AC4C58A51A4")!,
        name: "Drifting Snowdrift", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -4.2421, vcoPulseWidth: 0.3861, vcoPwmSource: .manual,
        mixSawLevel: 0.6884, mixPulseLevel: 0.5271, mixSubLevel: 0.1494, mixNoiseLevel: 0.1158, mixSubMode: .minus2Square,
        filterCutoff: 2154.7418, filterResonance: 0.5718, filterEnvAmount: 0.5868, filterLfoOn: false, filterKeyFollow: 0.3932,
        attack: 0.0088, decay: 0.5281, sustain: 0.6441, release: 0.5594,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 7.896, lfoDepth: 0.1942, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 4.6743, benderVcfSens: 1.8211, portamentoTime: 0.043, portamentoOn: false,
        echoVolume: 0.2021, echoTime: 0.2287, echoRepeat: 0.2475,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let cliffRatchet = SynthPreset(
        id: UUID(uuidString: "B35C4F17-4941-4625-A4A0-620A86298CC3")!,
        name: "Cliff Ratchet", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.85, vcoPulseWidth: 0.519, vcoPwmSource: .manual,
        mixSawLevel: 0.355, mixPulseLevel: 0.4942, mixSubLevel: 0.9236, mixNoiseLevel: 0.118, mixSubMode: .minus1Square,
        filterCutoff: 124.8615, filterResonance: 0.2969, filterEnvAmount: 0.2294, filterLfoOn: true, filterKeyFollow: 0.2486,
        attack: 3.4678, decay: 1.5733, sustain: 0.9508, release: 4.6729,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.1003, lfoDepth: 0.4399, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.8363, benderVcfSens: 0.4785, portamentoTime: 1.9387, portamentoOn: true,
        echoVolume: 0.5462, echoTime: 3.0266, echoRepeat: 0.7064,
        limiterThreshold: -4.9176, limiterCeiling: 0
    )

    static let buriedReef = SynthPreset(
        id: UUID(uuidString: "94E3688F-657A-48B2-85C5-FA592D10CEE1")!,
        name: "Buried Reef", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 0.563, vcoPulseWidth: 0.5362, vcoPwmSource: .manual,
        mixSawLevel: 0.4876, mixPulseLevel: 0.6594, mixSubLevel: 0.0566, mixNoiseLevel: 0.022, mixSubMode: .minus2Pulse,
        filterCutoff: 4878.7408, filterResonance: 0.2742, filterEnvAmount: 0.5028, filterLfoOn: false, filterKeyFollow: 0.7873,
        attack: 0.0034, decay: 1.7376, sustain: 0.1089, release: 1.0586,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 2.4605, lfoDepth: 0.0445, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.165, benderVcfSens: 0.4431, portamentoTime: 0.055, portamentoOn: false,
        echoVolume: 0.5076, echoTime: 0.482, echoRepeat: 0.3249,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let mistFilament = SynthPreset(
        id: UUID(uuidString: "F643F83A-E6FB-48E2-B902-78B1DA2D0CDA")!,
        name: "Mist Filament", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -1.9499, vcoPulseWidth: 0.4612, vcoPwmSource: .env,
        mixSawLevel: 0.0493, mixPulseLevel: 0.0547, mixSubLevel: 0.2212, mixNoiseLevel: 0.7826, mixSubMode: .minus2Pulse,
        filterCutoff: 259.0077, filterResonance: 0.7147, filterEnvAmount: 0.4872, filterLfoOn: true, filterKeyFollow: 0.7225,
        attack: 0.0061, decay: 1.8885, sustain: 0.7086, release: 0.173,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 2.3867, lfoDepth: 0.3667, lfoToPitchOn: true,
        arpMode: .up, arpOctaves: 1, arpHold: true, arpRate: 6.5915,
        benderVcoSens: 6.7882, benderVcfSens: 0.7122, portamentoTime: 0.0494, portamentoOn: false,
        echoVolume: 0.7615, echoTime: 0.4697, echoRepeat: 0.6658,
        limiterThreshold: -7.6593, limiterCeiling: 0
    )

    static let waningDriftwood = SynthPreset(
        id: UUID(uuidString: "C6DB8A7C-3896-4357-87A7-72CC46412162")!,
        name: "Waning Driftwood", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 0.7248, vcoPulseWidth: 0.3548, vcoPwmSource: .manual,
        mixSawLevel: 0.4826, mixPulseLevel: 0.5939, mixSubLevel: 0.2112, mixNoiseLevel: 0.0096, mixSubMode: .minus2Square,
        filterCutoff: 2715.5653, filterResonance: 0.3932, filterEnvAmount: 0.341, filterLfoOn: false, filterKeyFollow: 0.3736,
        attack: 0.0071, decay: 0.1945, sustain: 0.4272, release: 0.4342,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 6.6188, lfoDepth: 0.1618, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 3, arpHold: true, arpRate: 9.3594,
        benderVcoSens: 3.7563, benderVcfSens: 1.1, portamentoTime: 0.0739, portamentoOn: false,
        echoVolume: 0.3872, echoTime: 0.3712, echoRepeat: 0.5296,
        limiterThreshold: -3.7949, limiterCeiling: 0
    )

    static let prairieCoolant = SynthPreset(
        id: UUID(uuidString: "67300BBF-55A6-45B7-84CA-DED8A2546BD6")!,
        name: "Prairie Coolant", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 0.2031, vcoPulseWidth: 0.3152, vcoPwmSource: .lfo,
        mixSawLevel: 0.2685, mixPulseLevel: 0.1567, mixSubLevel: 0.145, mixNoiseLevel: 0.7582, mixSubMode: .minus2Pulse,
        filterCutoff: 1492.3653, filterResonance: 0.4319, filterEnvAmount: 0.4197, filterLfoOn: true, filterKeyFollow: 0.2003,
        attack: 0.4583, decay: 0.8697, sustain: 0.3947, release: 1.6298,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 1.3713, lfoDepth: 0.5558, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.6882, benderVcfSens: 1.0397, portamentoTime: 0.3365, portamentoOn: false,
        echoVolume: 0.4733, echoTime: 0.7808, echoRepeat: 0.4587,
        limiterThreshold: -3.4423, limiterCeiling: 0
    )

    static let hollowDriftwood = SynthPreset(
        id: UUID(uuidString: "7552059C-BE9C-40D4-9A3F-6EA1B5F7A7DD")!,
        name: "Hollow Driftwood", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 1.5767, vcoPulseWidth: 0.4761, vcoPwmSource: .lfo,
        mixSawLevel: 0.5392, mixPulseLevel: 0.3514, mixSubLevel: 0.4078, mixNoiseLevel: 0.0897, mixSubMode: .minus1Square,
        filterCutoff: 1728.3681, filterResonance: 0.2182, filterEnvAmount: 0.35, filterLfoOn: true, filterKeyFollow: 0.351,
        attack: 1.4666, decay: 1.1248, sustain: 0.7367, release: 3.5276,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.4173, lfoDepth: 0.4635, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.7715, benderVcfSens: 0.4967, portamentoTime: 1.5366, portamentoOn: true,
        echoVolume: 0.5012, echoTime: 1.0521, echoRepeat: 0.5027,
        limiterThreshold: -3.8138, limiterCeiling: 0
    )

    static let mutedAsh = SynthPreset(
        id: UUID(uuidString: "0FE48F5D-4266-4712-B43E-E1B2FAD70D57")!,
        name: "Muted Ash", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.8407, vcoPulseWidth: 0.4555, vcoPwmSource: .manual,
        mixSawLevel: 0.1574, mixPulseLevel: 0.5236, mixSubLevel: 0.9082, mixNoiseLevel: 0.134, mixSubMode: .minus1Square,
        filterCutoff: 411.6344, filterResonance: 0.4847, filterEnvAmount: -0.0142, filterLfoOn: false, filterKeyFollow: 0.5193,
        attack: 0.0048, decay: 0.2233, sustain: 0.7483, release: 0.2854,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 4.2471, lfoDepth: 0.2464, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.6864, benderVcfSens: 0.1857, portamentoTime: 0.1911, portamentoOn: false,
        echoVolume: 0.2167, echoTime: 0.2395, echoRepeat: 0.2374,
        limiterThreshold: -2.0727, limiterCeiling: -0.8845
    )

    static let silentMoraine = SynthPreset(
        id: UUID(uuidString: "A351BE1A-D5C6-4E5E-8EF2-8A707613F8D8")!,
        name: "Silent Moraine", createdAt: referenceDate,
        vcoRange: .two, vcoTune: -0.0109, vcoPulseWidth: 0.2697, vcoPwmSource: .env,
        mixSawLevel: 0.7915, mixPulseLevel: 0.6438, mixSubLevel: 0.1168, mixNoiseLevel: 0.1037, mixSubMode: .minus1Square,
        filterCutoff: 2895.3868, filterResonance: 0.3501, filterEnvAmount: 0.6189, filterLfoOn: false, filterKeyFollow: 0.4188,
        attack: 0.0168, decay: 0.5386, sustain: 0.5263, release: 0.5819,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 7.3345, lfoDepth: 0.0941, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 3.6743, benderVcfSens: 1.7765, portamentoTime: 0.0342, portamentoOn: false,
        echoVolume: 0.3251, echoTime: 0.3057, echoRepeat: 0.3141,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let groveCircuit = SynthPreset(
        id: UUID(uuidString: "54B12881-CC96-43CE-BEFE-3948787106F1")!,
        name: "Grove Circuit", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: -0.6986, vcoPulseWidth: 0.4905, vcoPwmSource: .manual,
        mixSawLevel: 0.3296, mixPulseLevel: 0.3258, mixSubLevel: 0.748, mixNoiseLevel: 0.1854, mixSubMode: .minus1Square,
        filterCutoff: 144.7023, filterResonance: 0.4356, filterEnvAmount: 0.099, filterLfoOn: true, filterKeyFollow: 0.2328,
        attack: 3.8086, decay: 1.9478, sustain: 0.9033, release: 3.7781,
        vcaMode: .gate,
        lfoWaveform: .triangle, lfoRate: 0.2459, lfoDepth: 0.4613, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.9994, benderVcfSens: 0.2969, portamentoTime: 1.7978, portamentoOn: true,
        echoVolume: 0.5565, echoTime: 2.7724, echoRepeat: 0.636,
        limiterThreshold: -5.7809, limiterCeiling: 0
    )

    static let waningBackwater = SynthPreset(
        id: UUID(uuidString: "721E3D32-51D3-4D23-9D55-A293E102765B")!,
        name: "Waning Backwater", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 1.3125, vcoPulseWidth: 0.4997, vcoPwmSource: .manual,
        mixSawLevel: 0.5081, mixPulseLevel: 0.8486, mixSubLevel: 0.0032, mixNoiseLevel: 0.0204, mixSubMode: .minus2Pulse,
        filterCutoff: 5083.4938, filterResonance: 0.4184, filterEnvAmount: 0.5141, filterLfoOn: false, filterKeyFollow: 0.8973,
        attack: 0.0057, decay: 1.6354, sustain: 0.1655, release: 1.2838,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 2.1939, lfoDepth: 0.0821, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 1.5457, benderVcfSens: 0.5444, portamentoTime: 0.055, portamentoOn: false,
        echoVolume: 0.5101, echoTime: 0.5001, echoRepeat: 0.406,
        limiterThreshold: -3, limiterCeiling: 0
    )

    static let overcastMoraine = SynthPreset(
        id: UUID(uuidString: "52E91E7B-59D2-47F5-96BA-5E43550868DB")!,
        name: "Overcast Moraine", createdAt: referenceDate,
        vcoRange: .eight, vcoTune: -0.1041, vcoPulseWidth: 0.3547, vcoPwmSource: .env,
        mixSawLevel: 0.1147, mixPulseLevel: 0.2412, mixSubLevel: 0.2226, mixNoiseLevel: 0.7942, mixSubMode: .minus2Pulse,
        filterCutoff: 120.0556, filterResonance: 0.6814, filterEnvAmount: 0.4852, filterLfoOn: true, filterKeyFollow: 0.6104,
        attack: 0.0077, decay: 2.888, sustain: 0.7434, release: 0.128,
        vcaMode: .gate,
        lfoWaveform: .sh, lfoRate: 3.7861, lfoDepth: 0.4515, lfoToPitchOn: true,
        arpMode: .off, arpOctaves: 1, arpHold: true, arpRate: 7.9118,
        benderVcoSens: 4.3117, benderVcfSens: 0.5156, portamentoTime: 0.057, portamentoOn: false,
        echoVolume: 0.822, echoTime: 0.5659, echoRepeat: 0.6378,
        limiterThreshold: -9.4137, limiterCeiling: 0
    )

    static let waningHeath = SynthPreset(
        id: UUID(uuidString: "B008E917-91BA-4FB1-B443-39CBB0277454")!,
        name: "Waning Heath", createdAt: referenceDate,
        vcoRange: .two, vcoTune: 6.4288, vcoPulseWidth: 0.5807, vcoPwmSource: .lfo,
        mixSawLevel: 0.6218, mixPulseLevel: 0.4472, mixSubLevel: 0.1821, mixNoiseLevel: 0.1422, mixSubMode: .minus2Pulse,
        filterCutoff: 1303.5214, filterResonance: 0.3, filterEnvAmount: 0.4298, filterLfoOn: false, filterKeyFollow: 0.3034,
        attack: 0.0108, decay: 0.2636, sustain: 0.569, release: 0.4394,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 7.0136, lfoDepth: 0.0723, lfoToPitchOn: false,
        arpMode: .updown, arpOctaves: 3, arpHold: true, arpRate: 6.3854,
        benderVcoSens: 2.6178, benderVcfSens: 0.8994, portamentoTime: 0.0546, portamentoOn: false,
        echoVolume: 0.5002, echoTime: 0.3445, echoRepeat: 0.4012,
        limiterThreshold: -3.5316, limiterCeiling: 0
    )

    static let kelpAntenna = SynthPreset(
        id: UUID(uuidString: "BB314898-A184-4A13-AA26-52DB2E3FD9D9")!,
        name: "Kelp Antenna", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 2.9605, vcoPulseWidth: 0.3936, vcoPwmSource: .lfo,
        mixSawLevel: 0.2002, mixPulseLevel: 0.207, mixSubLevel: 0.1463, mixNoiseLevel: 0.6293, mixSubMode: .minus2Pulse,
        filterCutoff: 1548.6056, filterResonance: 0.572, filterEnvAmount: 0.4962, filterLfoOn: true, filterKeyFollow: 0.3434,
        attack: 0.4355, decay: 0.4146, sustain: 0.3341, release: 1.963,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 0.6914, lfoDepth: 0.5561, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.9876, benderVcfSens: 0.9165, portamentoTime: 0.2684, portamentoOn: false,
        echoVolume: 0.3015, echoTime: 0.7907, echoRepeat: 0.5347,
        limiterThreshold: -3.1161, limiterCeiling: 0
    )

    static let prairieSignal = SynthPreset(
        id: UUID(uuidString: "22076BB6-BFA6-4A7E-965F-55E59F9689FE")!,
        name: "Prairie Signal", createdAt: referenceDate,
        vcoRange: .four, vcoTune: 0.788, vcoPulseWidth: 0.5208, vcoPwmSource: .manual,
        mixSawLevel: 0.3583, mixPulseLevel: 0.4879, mixSubLevel: 0.3146, mixNoiseLevel: 0.0166, mixSubMode: .minus1Square,
        filterCutoff: 883.4425, filterResonance: 0.165, filterEnvAmount: 0.2264, filterLfoOn: true, filterKeyFollow: 0.3345,
        attack: 2.0607, decay: 1.2412, sustain: 0.7003, release: 3.8165,
        vcaMode: .env,
        lfoWaveform: .triangle, lfoRate: 0.2531, lfoDepth: 0.2881, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.1335, benderVcfSens: 0.7489, portamentoTime: 1.7769, portamentoOn: true,
        echoVolume: 0.3659, echoTime: 2.3849, echoRepeat: 0.5061,
        limiterThreshold: -3.761, limiterCeiling: 0
    )

    static let glacierSolder = SynthPreset(
        id: UUID(uuidString: "21ECE383-466E-4F9B-AD86-4E19E8012C7A")!,
        name: "Glacier Solder", createdAt: referenceDate,
        vcoRange: .sixteen, vcoTune: 0.3213, vcoPulseWidth: 0.4932, vcoPwmSource: .manual,
        mixSawLevel: 0.3291, mixPulseLevel: 0.3784, mixSubLevel: 0.6991, mixNoiseLevel: 0.141, mixSubMode: .minus1Square,
        filterCutoff: 203.2946, filterResonance: 0.5865, filterEnvAmount: -0.1495, filterLfoOn: false, filterKeyFollow: 0.6574,
        attack: 0.0072, decay: 0.2312, sustain: 0.7069, release: 0.4764,
        vcaMode: .env,
        lfoWaveform: .sh, lfoRate: 4.8083, lfoDepth: 0.1204, lfoToPitchOn: false,
        arpMode: .off, arpOctaves: 1, arpHold: false, arpRate: 5,
        benderVcoSens: 2.6621, benderVcfSens: 0.0142, portamentoTime: 0.0517, portamentoOn: false,
        echoVolume: 0.1972, echoTime: 0.1589, echoRepeat: 0.2279,
        limiterThreshold: -2.2, limiterCeiling: -0.6242
    )
}
