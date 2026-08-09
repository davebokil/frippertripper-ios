import Foundation
import Observation

/// Persists the preset library to `UserDefaults` as a single JSON-encoded array -
/// simple and sufficient for what's realistically a few dozen small structs, and
/// keeps things dependency-free (no need for a database for this). Declared in
/// `PrivacyInfo.xcprivacy` under the UserDefaults API-access reason.
@MainActor
@Observable
final class PresetStore {
    private(set) var presets: [SynthPreset] = []
    private let defaultsKey = "com.davebokil.frippertripper.presets"

    init() {
        load()
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
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([SynthPreset].self, from: data) else {
            presets = FactoryPresets.all
            persist()
            return
        }
        presets = decoded
    }
}
