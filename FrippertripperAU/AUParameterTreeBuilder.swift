import AVFoundation

/// Builds the `AUParameterTree` exposed to hosts, mirroring `SynthEngine.swift`'s
/// ~35-parameter surface and grouped identically to `AUParameterID`'s `// MARK:`
/// sections. Default values match `SynthPreset.factoryDefault` so a host's
/// generic parameter UI starts in sync with what a freshly-created
/// `SynthEngineCore` actually sounds like.
enum AUParameterTreeBuilder {
    /// Builds a throwaway tree purely to read off each parameter's declared
    /// default - lets `FrippertripperAudioUnit.parameterCache` get an inline
    /// default value (computed before `super.init()`, alongside `core`) instead
    /// of needing a real `AUParameterTree` instance to already exist.
    static func defaultParameterValues() -> [Float] {
        let tree = makeTree()
        return AUParameterID.allCases.map { Float(tree.parameter(withAddress: $0.rawValue)?.value ?? 0) }
    }

    static func makeTree() -> AUParameterTree {
        func continuous(_ id: AUParameterID, _ name: String, min: AUValue, max: AUValue, unit: AudioUnitParameterUnit = .generic, default value: AUValue, logarithmic: Bool = false) -> AUParameterNode {
            let param = AUParameterTree.createParameter(
                withIdentifier: "\(id)", name: name, address: id.rawValue,
                min: min, max: max, unit: unit, unitName: nil,
                flags: logarithmic ? [.flag_IsReadable, .flag_IsWritable, .flag_DisplayLogarithmic] : [.flag_IsReadable, .flag_IsWritable],
                valueStrings: nil, dependentParameters: nil
            )
            param.value = value
            return param
        }

        func indexed(_ id: AUParameterID, _ name: String, valueStrings: [String], default defaultIndex: Int) -> AUParameterNode {
            let param = AUParameterTree.createParameter(
                withIdentifier: "\(id)", name: name, address: id.rawValue,
                min: 0, max: AUValue(valueStrings.count - 1), unit: .indexed, unitName: nil,
                flags: [.flag_IsReadable, .flag_IsWritable], valueStrings: valueStrings, dependentParameters: nil
            )
            param.value = AUValue(defaultIndex)
            return param
        }

        func toggle(_ id: AUParameterID, _ name: String, default defaultOn: Bool) -> AUParameterNode {
            indexed(id, name, valueStrings: ["Off", "On"], default: defaultOn ? 1 : 0)
        }

        let vco = AUParameterTree.createGroup(withIdentifier: "vco", name: "VCO", children: [
            indexed(.vcoRange, "Range", valueStrings: VcoRange.allCases.map(\.rawValue), default: 1),
            continuous(.vcoTune, "Tune", min: -50, max: 50, unit: .cents, default: 3.7901),
            continuous(.vcoPulseWidth, "Pulse Width", min: 0.02, max: 0.98, unit: .percent, default: 0.9013),
            indexed(.vcoPwmSource, "PWM Source", valueStrings: PwmSource.allCases.map(\.rawValue), default: 0),
        ])

        let mixer = AUParameterTree.createGroup(withIdentifier: "mixer", name: "Source Mixer", children: [
            continuous(.mixSawLevel, "Saw Level", min: 0, max: 1, unit: .percent, default: 0.7441),
            continuous(.mixPulseLevel, "Pulse Level", min: 0, max: 1, unit: .percent, default: 0.5732),
            continuous(.mixSubLevel, "Sub Level", min: 0, max: 1, unit: .percent, default: 0.1792),
            continuous(.mixNoiseLevel, "Noise Level", min: 0, max: 1, unit: .percent, default: 0.202),
            indexed(.mixSubMode, "Sub Mode", valueStrings: SubMode.allCases.map(\.rawValue), default: 2),
        ])

        let filter = AUParameterTree.createGroup(withIdentifier: "filter", name: "Filter", children: [
            continuous(.filterCutoff, "Cutoff", min: 80, max: 12000, unit: .hertz, default: 156.8622, logarithmic: true),
            continuous(.filterResonance, "Resonance", min: 0, max: 0.8, unit: .percent, default: 0.0593),
            continuous(.filterEnvAmount, "Env Amount", min: -1, max: 1, default: 0.8067),
            toggle(.filterLfoOn, "LFO", default: false),
            continuous(.filterKeyFollow, "Key Follow", min: 0, max: 1, unit: .percent, default: 0.0603),
        ])

        let envelope = AUParameterTree.createGroup(withIdentifier: "envelope", name: "Envelope", children: [
            continuous(.attack, "Attack", min: 0.001, max: 3, unit: .seconds, default: 0.2996, logarithmic: true),
            continuous(.decay, "Decay", min: 0.02, max: 3, unit: .seconds, default: 0.1853, logarithmic: true),
            continuous(.sustain, "Sustain", min: 0, max: 1, unit: .percent, default: 0.7622),
            continuous(.release, "Release", min: 0.02, max: 5, unit: .seconds, default: 2.8338, logarithmic: true),
        ])

        let vca = AUParameterTree.createGroup(withIdentifier: "vca", name: "VCA", children: [
            indexed(.vcaMode, "Mode", valueStrings: VcaMode.allCases.map(\.rawValue), default: 0),
        ])

        let lfo = AUParameterTree.createGroup(withIdentifier: "lfo", name: "LFO", children: [
            indexed(.lfoWaveform, "Waveform", valueStrings: LfoWaveform.allCases.map(\.rawValue), default: 0),
            continuous(.lfoRate, "Rate", min: 0.1, max: 30, unit: .hertz, default: 3.006, logarithmic: true),
            continuous(.lfoDepth, "Depth", min: 0, max: 1, unit: .percent, default: 0.0308),
            toggle(.lfoToPitchOn, "To Pitch", default: false),
        ])

        let arp = AUParameterTree.createGroup(withIdentifier: "arp", name: "Arpeggiator", children: [
            indexed(.arpMode, "Mode", valueStrings: ArpMode.allCases.map(\.rawValue), default: 0),
            indexed(.arpOctaves, "Octaves", valueStrings: ["1", "2", "3", "4"], default: 2),
            toggle(.arpHold, "Hold", default: false),
            continuous(.arpRate, "Rate", min: 0.1, max: 30, unit: .hertz, default: 14.1744),
        ])

        let controller = AUParameterTree.createGroup(withIdentifier: "controller", name: "Controller", children: [
            continuous(.benderPosition, "Bender Position", min: -1, max: 1, default: 0),
            continuous(.benderVcoSens, "Bender VCO Sens", min: 0, max: 12, unit: .cents, default: 0.3078),
            continuous(.benderVcfSens, "Bender VCF Sens", min: 0, max: 4, default: 0.1779),
            continuous(.portamentoTime, "Portamento Time", min: 0.02, max: 5, unit: .seconds, default: 3.4664, logarithmic: true),
            toggle(.portamentoOn, "Portamento", default: false),
        ])

        let echo = AUParameterTree.createGroup(withIdentifier: "echo", name: "Echo", children: [
            continuous(.echoVolume, "Volume", min: 0, max: 1, unit: .percent, default: 0.6077),
            continuous(.echoTime, "Time", min: 0, max: 4, unit: .seconds, default: 2.6569),
            continuous(.echoRepeat, "Repeat", min: 0, max: 1, unit: .percent, default: 0.6978),
        ])

        let limiter = AUParameterTree.createGroup(withIdentifier: "limiter", name: "Limiter", children: [
            continuous(.limiterThreshold, "Threshold", min: -24, max: 0, unit: .decibels, default: -3),
            continuous(.limiterCeiling, "Ceiling", min: -24, max: 0, unit: .decibels, default: 0),
        ])

        return AUParameterTree.createTree(withChildren: [vco, mixer, filter, envelope, vca, lfo, arp, controller, echo, limiter])
    }
}
