import SwiftUI
import UIKit

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

    // TEMPORARY dev tool - see PresetCodeExporter.swift for removal notes.
    @State private var isCopyingPresetCode = false
    @State private var copyPresetCodeName = ""
    @State private var didCopyPresetCode = false

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
                // TEMPORARY dev tool - see PresetCodeExporter.swift for removal notes.
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        copyPresetCodeName = ""
                        isCopyingPresetCode = true
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                }
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
            // TEMPORARY dev tool - see PresetCodeExporter.swift for removal notes.
            .alert("Copy Current Settings as Code", isPresented: $isCopyingPresetCode) {
                TextField("Preset name", text: $copyPresetCodeName)
                Button("Cancel", role: .cancel) {}
                Button("Copy") {
                    let name = copyPresetCodeName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty else { return }
                    let preset = engine.makePreset(name: name)
                    UIPasteboard.general.string = PresetCodeExporter.swiftCode(for: preset)
                    didCopyPresetCode = true
                }
            }
            .alert("Copied", isPresented: $didCopyPresetCode) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Paste it into chat to add as a factory preset.")
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
