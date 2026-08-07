import SwiftUI

/// Always-visible, tappable segmented selector for the front panel's pages -
/// replaces reliance on swipe-only paging + small system page dots, which weren't a
/// discoverable enough hint that more parameters exist off-screen.
struct PageSelectorView: View {
    @Binding var selectedPage: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(frontPanelPageTitles.indices, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedPage = index }
                } label: {
                    Text(frontPanelPageTitles[index])
                        .font(.system(size: 11, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(selectedPage == index ? Color.orange.opacity(0.85) : Color(white: 0.14))
                        .foregroundStyle(selectedPage == index ? .black : .white.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
