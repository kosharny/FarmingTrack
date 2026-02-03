import SwiftUI

struct EmptyStateView: View {
    let message: String
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill") // Generic icon, can be overridden if needed later
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            Text(message)
                .font(.body)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
    }
}
