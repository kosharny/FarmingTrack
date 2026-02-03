import SwiftUI

struct AboutViewFT: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: "About", showBackButton: true)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                        
                        Text("Farming Track")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Designed to help you master the art of farming. Track your crops, learn new skills, and manage your tasks efficiently.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.8))
                            .padding()
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
