import SwiftUI

struct SectionHeaderFT: View {
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.FT.softOrange)
            Spacer()
            if let action = action {
                Button("See All", action: action)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}
