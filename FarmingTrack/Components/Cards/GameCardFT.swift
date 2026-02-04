import SwiftUI

struct GameCardFT<Content: View>: View {
    let content: Content
    let contentPadding: CGFloat
    
    init(contentPadding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.contentPadding = contentPadding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(contentPadding)
            .background(Color.FT.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.FT.cardBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        MainBackgroundFT()
        GameCardFT {
            Text("This is a Game Card")
                .foregroundColor(.white)
        }
    }
}
