import SwiftUI

struct BadgeFT: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text.uppercased())
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.8))
            .clipShape(Capsule())
            .foregroundColor(.white)
    }
}
