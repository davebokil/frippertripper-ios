import XCTest
@testable import Frippertripper

@MainActor
final class PresetTests: XCTestCase {
    func testMakePresetCapturesCurrentEngineState() {
        let engine = SynthEngine(core: SynthEngineCore())
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
        let source = SynthEngine(core: SynthEngineCore())
        source.vcoRange = .sixteen
        source.mixNoiseLevel = 0.8
        source.arpMode = .updown
        source.arpOctaves = 3
        source.echoRepeat = 0.9
        let preset = source.makePreset(name: "Test")

        let target = SynthEngine(core: SynthEngineCore())
        XCTAssertNotEqual(target.vcoRange, .sixteen) // sanity: differs before applying

        target.apply(preset)

        XCTAssertEqual(target.vcoRange, .sixteen)
        XCTAssertEqual(target.mixNoiseLevel, 0.8)
        XCTAssertEqual(target.arpMode, .updown)
        XCTAssertEqual(target.arpOctaves, 3)
        XCTAssertEqual(target.echoRepeat, 0.9)
    }

    func testPresetRoundTripsThroughJSON() throws {
        let engine = SynthEngine(core: SynthEngineCore())
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

        // `SynthEngine.saveSession()`/`restoreLastSession()` always read/write
        // `UserDefaults.standard` (this is per-launch app continuity, not the
        // shared preset library - see `testPresetStoreSharesDataAcrossInstancesViaAppGroupSuite`
        // for that), so verify the round-trip contract they rely on against an
        // isolated suite rather than polluting `.standard` from the test run.
        let source = SynthEngine(core: SynthEngineCore())
        source.vcoRange = .four
        source.filterCutoff = 2200
        source.echoRepeat = 0.6
        let snapshot = source.makePreset(name: "")
        let data = try JSONEncoder().encode(snapshot)
        defaults.set(data, forKey: "lastSession")

        let reloadedData = try XCTUnwrap(defaults.data(forKey: "lastSession"))
        let reloaded = try JSONDecoder().decode(SynthPreset.self, from: reloadedData)

        let target = SynthEngine(core: SynthEngineCore())
        target.apply(reloaded)

        XCTAssertEqual(target.vcoRange, .four)
        XCTAssertEqual(target.filterCutoff, 2200)
        XCTAssertEqual(target.echoRepeat, 0.6)
    }

    func testStoreSaveRenameDeleteAndPersistAcrossInstances() throws {
        try withCleanPresetsStorage {
            let store = PresetStore()
            let engine = SynthEngine(core: SynthEngineCore())
            store.save(name: "Saved", from: engine)

            guard let saved = store.presets.first(where: { $0.name == "Saved" }) else {
                return XCTFail("expected a saved preset")
            }
            store.rename(saved, to: "Renamed")
            XCTAssertTrue(store.presets.contains { $0.name == "Renamed" })

            store.delete(saved)
            XCTAssertFalse(store.presets.contains { $0.id == saved.id })

            // Reconstructing a store (standing in for a fresh launch) must see the
            // same final state, proving persistence actually round-trips rather
            // than only living in `store`'s in-memory array.
            store.save(name: "Persisted", from: engine)
            let reloaded = PresetStore()
            XCTAssertTrue(reloaded.presets.contains { $0.name == "Persisted" })
        }
    }

    /// This is the actual mechanism `FrippertripperAU` depends on to share
    /// presets with the host app (see docs/auv3-plan.md Stage 5): two
    /// independently-constructed `PresetStore` instances against the real
    /// `group.com.davebokil.frippertripper` suite, standing in for "the app" and
    /// "the extension", must see each other's writes.
    func testPresetStoreSharesDataAcrossInstancesViaAppGroupSuite() throws {
        try withCleanPresetsStorage {
            let appSideStore = PresetStore()
            XCTAssertEqual(appSideStore.presets.count, FactoryPresets.all.count)

            appSideStore.save(name: "Shared From Host", from: SynthEngine(core: SynthEngineCore()))

            let extensionSideStore = PresetStore()
            XCTAssertTrue(extensionSideStore.presets.contains { $0.name == "Shared From Host" })
            XCTAssertEqual(extensionSideStore.presets.count, appSideStore.presets.count)
        }
    }

    /// Regression test for a real bug found on-device: a user who loads the
    /// plugin in a host before ever launching the standalone app once (an
    /// entirely ordinary thing to do) would previously see the factory bank
    /// permanently missing, because only the app was allowed to seed it and by
    /// the time it launched, the extension had already made the App-Group
    /// container non-empty with just the user's own saved presets. Either side
    /// constructing first against a truly empty container must seed - see
    /// `PresetStore`'s doc comment.
    func testPresetStoreSeedsFactoryPresetsWhenExtensionConstructsFirst() throws {
        try withCleanPresetsStorage {
            // Simulates "the extension loads before the app has ever launched" -
            // this used to leave `presets` empty; it must now seed like any other
            // first-ever construction against an empty container.
            let store = PresetStore()
            XCTAssertEqual(store.presets.count, FactoryPresets.all.count)
        }
    }

    func testPresetStoreMigratesLegacyStandardDataIntoAppGroupSuite() throws {
        try withCleanPresetsStorage {
            // A pre-App-Group install (already shipped to TestFlight before this
            // migration existed) has its presets under `.standard`.
            let legacyPreset = SynthEngine(core: SynthEngineCore()).makePreset(name: "Legacy")
            let legacyData = try JSONEncoder().encode([legacyPreset])
            UserDefaults.standard.set(legacyData, forKey: Self.presetsKey)

            let store = PresetStore()
            XCTAssertEqual(store.presets.map(\.name), ["Legacy"])

            // The migration must have actually landed in the group suite (so a
            // second instance - the extension - sees it too), not just been held
            // in this one instance's memory.
            let groupDefaults = try XCTUnwrap(UserDefaults(suiteName: Self.appGroupSuiteName))
            let migratedData = try XCTUnwrap(groupDefaults.data(forKey: Self.presetsKey))
            let migrated = try JSONDecoder().decode([SynthPreset].self, from: migratedData)
            XCTAssertEqual(migrated.map(\.name), ["Legacy"])
        }
    }

    // MARK: - Helpers

    private static let appGroupSuiteName = "group.com.davebokil.frippertripper"
    private static let presetsKey = "com.davebokil.frippertripper.presets"

    /// `PresetStore` hardcodes the real App-Group suite name (no test-only seam -
    /// consistent with this project's minimal-abstraction style), so these tests
    /// exercise that actual suite plus `.standard`. Snapshots and restores both so
    /// a test run never permanently loses whatever this simulator's manually
    /// launched app already had saved.
    private func withCleanPresetsStorage(_ body: () throws -> Void) throws {
        let groupDefaults = try XCTUnwrap(UserDefaults(suiteName: Self.appGroupSuiteName))
        let originalGroupData = groupDefaults.data(forKey: Self.presetsKey)
        let originalStandardData = UserDefaults.standard.data(forKey: Self.presetsKey)
        groupDefaults.removeObject(forKey: Self.presetsKey)
        UserDefaults.standard.removeObject(forKey: Self.presetsKey)
        defer {
            setOrRemove(originalGroupData, forKey: Self.presetsKey, in: groupDefaults)
            setOrRemove(originalStandardData, forKey: Self.presetsKey, in: .standard)
        }
        try body()
    }

    private func setOrRemove(_ data: Data?, forKey key: String, in defaults: UserDefaults) {
        if let data {
            defaults.set(data, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }
}
