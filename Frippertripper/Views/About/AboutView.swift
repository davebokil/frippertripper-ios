import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("ABOUT FRIPPERTRIPPER")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.secondary)
                    .tracking(1.2)

                Text("Frippertripper is synthesizer and tape-echo delay/looper inspired by Frippertronics.")
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                HStack(spacing: 4) {
                    Text("made with ♥ by")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Link("dave bokil", destination: URL(string: "https://davebokil.com/")!)
                        .font(.footnote)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
