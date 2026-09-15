import Foundation
import Observation

/// Persists the preset library to `UserDefaults` as a single JSON-encoded array -
/// simple and sufficient for what's realistically a few dozen small structs, and
/// keeps things dependency-free (no need for a database for this). Declared in
/// `PrivacyInfo.xcprivacy` under the UserDefaults API-access reason.
///
/// Uses the `group.com.davebokil.frippertripper` App Group suite (not `.standard`)
/// so the AUv3 extension's own sandbox can see the same preset library as the host
/// app. Falls back to `.standard` if the suite is ever unavailable (e.g. entitlement
/// not yet provisioned) rather than silently losing the preset library.
///
/// Either side - the standalone app or the AUv3 extension - may seed the factory
/// library, whichever constructs this first against a truly empty (no data key at
/// all) App-Group container. An earlier version restricted seeding to the app
/// only, reasoning that letting both sides seed risked a race - but the actual
/// worst case of a race is both sides writing the identical canonical
/// `FactoryPresets.all`, which is harmless. Restricting it to the app was worse in
/// practice, and was confirmed as a real bug via on-device testing: a user who
/// loads the plugin in a host (GarageBand, AUM) before ever launching the app once
/// - a completely ordinary thing to do - would have the extension populate the
/// container with just their own saved presets, and the app would then see "data
/// already exists" and skip seeding forever, making the factory bank look
/// permanently missing.
@MainActor
@Observable
final class PresetStore {
    private(set) var presets: [SynthPreset] = []
    private let defaultsKey = "com.davebokil.frippertripper.presets"
    private static let appGroupSuiteName = "group.com.davebokil.frippertripper"
    private let defaults: UserDefaults

    init() {
        defaults = UserDefaults(suiteName: Self.appGroupSuiteName) ?? .standard
        migrateFromStandardIfNeeded()
        load()
    }

    /// One-time migration for installs from before the App Group suite existed:
    /// if the group suite has no data yet but the legacy `.standard` suite does,
    /// copy it over. Never overwrites existing group-suite data.
    private func migrateFromStandardIfNeeded() {
        guard defaults !== UserDefaults.standard else { return }
        guard defaults.data(forKey: defaultsKey) == nil,
              let legacyData = UserDefaults.standard.data(forKey: defaultsKey) else { return }
        defaults.set(legacyData, forKey: defaultsKey)
    }

    func save(name: String, from engine: SynthEngine) {
        presets.append(engine.makePreset(name: name))
        persist()
    }

    func update(_ preset: SynthPreset, from engine: SynthEngine) {
        guard let index = presets.firstIndex(where: { $0.id == preset.id }) else { return }
        presets[index] = engine.makePreset(id: preset.id, name: preset.name, createdAt: preset.createdAt)
        persist()
    }

    func rename(_ preset: SynthPreset, to newName: String) {
        guard let index = presets.firstIndex(where: { $0.id == preset.id }) else { return }
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        presets[index].name = trimmed
        persist()
    }

    func delete(_ preset: SynthPreset) {
        presets.removeAll { $0.id == preset.id }
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(presets) else { return }
        defaults.set(data, forKey: defaultsKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([SynthPreset].self, from: data) else {
            presets = FactoryPresets.all
            persist()
            return
        }
        presets = decoded
    }
}
