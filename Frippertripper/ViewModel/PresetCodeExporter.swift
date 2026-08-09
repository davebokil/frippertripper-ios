import Foundation

/// TEMPORARY dev tool: formats a `SynthPreset` as a Swift literal in the exact
/// style used by `FactoryPresets.swift`, so a preset designed on-device can be
/// copied to the clipboard and handed back verbatim to add to the factory bank.
/// Delete this file (and its call site in `PresetsView`) once the factory
/// preset bank is finalized.
enum PresetCodeExporter {
    static func swiftCode(for preset: SynthPreset) -> String {
        """
        static let \(variableName(for: preset.name)) = SynthPreset(
            id: UUID(uuidString: "\(UUID().uuidString)")!,
            name: "\(preset.name)", createdAt: referenceDate,
            vcoRange: \(literal(preset.vcoRange)), vcoTune: \(f(preset.vcoTune)), vcoPulseWidth: \(f(preset.vcoPulseWidth)), vcoPwmSource: .\(preset.vcoPwmSource.rawValue),
            mixSawLevel: \(f(preset.mixSawLevel)), mixPulseLevel: \(f(preset.mixPulseLevel)), mixSubLevel: \(f(preset.mixSubLevel)), mixNoiseLevel: \(f(preset.mixNoiseLevel)), mixSubMode: .\(preset.mixSubMode.rawValue),
            filterCutoff: \(f(preset.filterCutoff)), filterResonance: \(f(preset.filterResonance)), filterEnvAmount: \(f(preset.filterEnvAmount)), filterLfoOn: \(preset.filterLfoOn), filterKeyFollow: \(f(preset.filterKeyFollow)),
            attack: \(f(preset.attack)), decay: \(f(preset.decay)), sustain: \(f(preset.sustain)), release: \(f(preset.release)),
            vcaMode: .\(preset.vcaMode.rawValue),
            lfoWaveform: .\(preset.lfoWaveform.rawValue), lfoRate: \(f(preset.lfoRate)), lfoDepth: \(f(preset.lfoDepth)), lfoToPitchOn: \(preset.lfoToPitchOn),
            arpMode: .\(preset.arpMode.rawValue), arpOctaves: \(preset.arpOctaves), arpHold: \(preset.arpHold), arpRate: \(f(preset.arpRate)),
            benderVcoSens: \(f(preset.benderVcoSens)), benderVcfSens: \(f(preset.benderVcfSens)), portamentoTime: \(f(preset.portamentoTime)), portamentoOn: \(preset.portamentoOn),
            echoVolume: \(f(preset.echoVolume)), echoTime: \(f(preset.echoTime)), echoRepeat: \(f(preset.echoRepeat)),
            limiterThreshold: \(f(preset.limiterThreshold)), limiterCeiling: \(f(preset.limiterCeiling))
        )
        """
    }

    private static func literal(_ range: VcoRange) -> String {
        switch range {
        case .sixteen: ".sixteen"
        case .eight: ".eight"
        case .four: ".four"
        case .two: ".two"
        }
    }

    /// Trims float noise (e.g. 0.30000001) to at most 4 decimal places, and
    /// drops the decimal point entirely for whole numbers.
    private static func f(_ value: Float) -> String {
        let rounded = (value * 10000).rounded() / 10000
        if rounded == rounded.rounded() {
            return String(Int(rounded))
        }
        var text = String(format: "%.4f", rounded)
        while text.hasSuffix("0") { text.removeLast() }
        if text.hasSuffix(".") { text.removeLast() }
        return text
    }

    private static func variableName(for presetName: String) -> String {
        let words = presetName.split(whereSeparator: { !$0.isLetter && !$0.isNumber })
        guard let first = words.first else { return "newPreset" }
        let rest = words.dropFirst().map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
        return (first.lowercased() + rest.joined())
    }
}
