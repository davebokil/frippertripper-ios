import SwiftUI

/// Save/load sheet for the global preset library: a preset captures every synth,
/// echo, and limiter parameter as one snapshot (per the user's request), not
/// per-section presets.
struct PresetsView: View {
    @Bindable var engine: SynthEngine
    @Bindable var presetStore: PresetStore
    @Environment(\.dismiss) private var dismiss

    @State private var isAddingPreset = false
    @State private var newPresetName = ""
    @State private var renamingPreset: SynthPreset?
    @State private var renameText = ""

    var body: some View {
        NavigationStack {
            List {
                if presetStore.presets.isEmpty {
                    Text("No presets yet. Tap + to save the current synth, echo, and limiter settings.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                ForEach(presetStore.presets) { preset in
                    Button {
                        engine.apply(preset)
                        dismiss()
                    } label: {
                        Text(preset.name)
                            .foregroundStyle(.primary)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            presetStore.delete(preset)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button {
                            presetStore.update(preset, from: engine)
                        } label: {
                            Label("Update with Current Settings", systemImage: "arrow.triangle.2.circlepath")
                        }
                        Button {
                            renameText = preset.name
                            renamingPreset = preset
                        } label: {
                            Label("Rename", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            presetStore.delete(preset)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Presets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        newPresetName = ""
                        isAddingPreset = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Save Preset", isPresented: $isAddingPreset) {
                TextField("Preset name", text: $newPresetName)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    let name = newPresetName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty else { return }
                    presetStore.save(name: name, from: engine)
                }
            }
            .alert(
                "Rename Preset",
                isPresented: Binding(get: { renamingPreset != nil }, set: { if !$0 { renamingPreset = nil } })
            ) {
                TextField("Preset name", text: $renameText)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    if let preset = renamingPreset {
                        presetStore.rename(preset, to: renameText)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
