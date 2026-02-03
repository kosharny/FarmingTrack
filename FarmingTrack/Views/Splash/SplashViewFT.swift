import SwiftUI

struct SplashViewFT: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            EmptyView() // Will be handled by parent
        } else {
            ZStack {
                MainBackgroundFT()
                
                VStack {
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                    Text("FARMING TRACK")
                        .font(.custom("HelveticaNeue-CondensedBlack", size: 36))
                        .foregroundColor(.white)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
