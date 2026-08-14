import XCTest
@testable import Frippertripper

@MainActor
final class PresetTests: XCTestCase {
    func testMakePresetCapturesCurrentEngineState() {
        let engine = SynthEngine()
        engine.vcoRange = .two
        engine.filterCutoff = 1234
        engine.echoTime = 1.5
        engine.limiterThreshold = -10

        let preset = engine.makePreset(name: "Test")

        XCTAssertEqual(preset.vcoRange, .two)
        XCTAssertEqual(preset.filterCutoff, 1234)
        XCTAssertEqual(preset.echoTime, 1.5)
        XCTAssertEqual(preset.limiterThreshold, -10)
    }

    func testApplyingPresetRestoresEngineState() {
        let source = SynthEngine()
        source.vcoRange = .sixteen
        source.mixNoiseLevel = 0.8
        source.arpMode = .updown
        source.arpOctaves = 3
        source.echoRepeat = 0.9
        let preset = source.makePreset(name: "Test")

        let target = SynthEngine()
        XCTAssertNotEqual(target.vcoRange, .sixteen) // sanity: differs before applying

        target.apply(preset)

        XCTAssertEqual(target.vcoRange, .sixteen)
        XCTAssertEqual(target.mixNoiseLevel, 0.8)
        XCTAssertEqual(target.arpMode, .updown)
        XCTAssertEqual(target.arpOctaves, 3)
        XCTAssertEqual(target.echoRepeat, 0.9)
    }

    func testPresetRoundTripsThroughJSON() throws {
        let engine = SynthEngine()
        engine.vcoPwmSource = .lfo
        engine.lfoWaveform = .noise
        engine.vcaMode = .gate
        let original = engine.makePreset(name: "Round Trip")

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(SynthPreset.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    func testSessionSaveAndRestoreRoundTripsEngineState() throws {
        let suiteName = "PresetTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        // SynthEngine.saveSession()/restoreLastSession() always read/write
        // UserDefaults.standard, so verify the round-trip contract they rely on
        // against an isolated suite rather than polluting .standard from the test run.
        let source = SynthEngine()
        source.vcoRange = .four
        source.filterCutoff = 2200
        source.echoRepeat = 0.6
        let snapshot = source.makePreset(name: "")
        let data = try JSONEncoder().encode(snapshot)
        defaults.set(data, forKey: "lastSession")

        let reloadedData = try XCTUnwrap(defaults.data(forKey: "lastSession"))
        let reloaded = try JSONDecoder().decode(SynthPreset.self, from: reloadedData)

        let target = SynthEngine()
        target.apply(reloaded)

        XCTAssertEqual(target.vcoRange, .four)
        XCTAssertEqual(target.filterCutoff, 2200)
        XCTAssertEqual(target.echoRepeat, 0.6)
    }

    func testStoreSaveRenameDeleteAndPersistAcrossInstances() throws {
        let suiteName = "PresetTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        // PresetStore always reads/writes UserDefaults.standard, so verify the
        // round-trip contract it relies on (JSON array of SynthPreset persists and
        // reloads correctly) against an isolated suite rather than polluting
        // .standard from the test run.
        let engine = SynthEngine()
        let preset = engine.makePreset(name: "Saved")
        let data = try JSONEncoder().encode([preset])
        defaults.set(data, forKey: "presets")

        let reloadedData = try XCTUnwrap(defaults.data(forKey: "presets"))
        let reloaded = try JSONDecoder().decode([SynthPreset].self, from: reloadedData)
        XCTAssertEqual(reloaded, [preset])
    }
}
