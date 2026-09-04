import XCTest
@testable import Frippertripper

/// `AUParameterMapping` is `AUAudioUnit`-independent by design (see its doc
/// comment) specifically so the address<->property mapping backing
/// `FrippertripperAU`'s `AUParameterTree` can be exercised here, even though the
/// standalone app never calls it at runtime.
final class AUParameterMappingTests: XCTestCase {
    private func makeCore() -> SynthEngineCore {
        let core = SynthEngineCore()
        core.prepare(sampleRate: 44100)
        return core
    }

    func testDirectContinuousParameterWritesThrough() {
        let core = makeCore()
        AUParameterMapping.write(address: AUParameterID.vcoTune.rawValue, value: 12.5, to: core)
        XCTAssertEqual(core.vcoTune, 12.5)

        AUParameterMapping.write(address: AUParameterID.filterCutoff.rawValue, value: 2500, to: core)
        XCTAssertEqual(core.filterCutoffKnob, 2500)
    }

    func testSmoothedContinuousParameterRampsTowardTarget() {
        let core = makeCore()
        AUParameterMapping.write(address: AUParameterID.mixSawLevel.rawValue, value: 0.9, to: core)

        // A single render call is one `RampedParameter.advance()` per sample -
        // enough samples at tau 0.01s/44.1kHz to get within a hair of the target
        // without waiting out the full ramp.
        var buffer = [Float](repeating: 0, count: 4096)
        buffer.withUnsafeMutableBufferPointer { core.render(frameCount: 4096, into: $0.baseAddress!) }

        XCTAssertEqual(core.mixSawLevelParam.value, 0.9, accuracy: 0.01)
    }

    func testIndexedEnumParameterMapsByAllCasesOrder() {
        let core = makeCore()
        let index = VcoRange.allCases.firstIndex(of: .two)!
        AUParameterMapping.write(address: AUParameterID.vcoRange.rawValue, value: Float(index), to: core)
        XCTAssertEqual(core.vcoRange, .two)
    }

    func testIndexedEnumParameterClampsOutOfRangeValue() {
        let core = makeCore()
        AUParameterMapping.write(address: AUParameterID.lfoWaveform.rawValue, value: 99, to: core)
        XCTAssertEqual(core.lfoWaveform, LfoWaveform.allCases.last)

        AUParameterMapping.write(address: AUParameterID.lfoWaveform.rawValue, value: -5, to: core)
        XCTAssertEqual(core.lfoWaveform, LfoWaveform.allCases.first)
    }

    func testBooleanParameterThresholdsAtHalf() {
        let core = makeCore()
        AUParameterMapping.write(address: AUParameterID.filterLfoOn.rawValue, value: 1, to: core)
        XCTAssertTrue(core.filterLfoOn)

        AUParameterMapping.write(address: AUParameterID.filterLfoOn.rawValue, value: 0, to: core)
        XCTAssertFalse(core.filterLfoOn)
    }

    /// `AUParameterTreeBuilder` advertises this as a 0-based indexed parameter
    /// labeled ["1","2","3","4"], but `core.arpOctaves` wants the actual octave
    /// count - this pins the +1 offset against a regression.
    func testArpOctavesOffsetsIndexToOctaveCount() {
        let core = makeCore()
        AUParameterMapping.write(address: AUParameterID.arpOctaves.rawValue, value: 0, to: core)
        XCTAssertEqual(core.arpOctaves, 1)

        AUParameterMapping.write(address: AUParameterID.arpOctaves.rawValue, value: 3, to: core)
        XCTAssertEqual(core.arpOctaves, 4)
    }

    func testLimiterThresholdParameterRoutesThroughDedicatedSetterAndAffectsOutput() {
        let core = makeCore()
        core.noteOn(id: 60, frequency: 440)
        // `limiterThreshold`/`limiterCeiling` have no direct stored-property
        // getter on `SynthEngineCore` (only their *mapped* gain-domain
        // `RampedParameter`s do), so prove the setter actually landed by driving
        // a loud held note well above a very low threshold and checking the
        // limiter's gain-reduction meter actually engaged.
        AUParameterMapping.write(address: AUParameterID.limiterThreshold.rawValue, value: -24, to: core)

        var buffer = [Float](repeating: 0, count: 8192)
        buffer.withUnsafeMutableBufferPointer { core.render(frameCount: 8192, into: $0.baseAddress!) }

        XCTAssertLessThan(core.limiterReductionDb, -1)
    }

    func testUnknownAddressIsIgnoredRatherThanCrashing() {
        let core = makeCore()
        AUParameterMapping.write(address: UInt64(AUParameterID.allCases.count + 100), value: 1, to: core)
        // No crash is the assertion; nothing else to check.
    }
}
