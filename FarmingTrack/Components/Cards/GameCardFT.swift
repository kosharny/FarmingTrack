import SwiftUI

struct GameCardFT<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.FT.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.FT.cardBorder, lineWidth: 1)
                    )
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
