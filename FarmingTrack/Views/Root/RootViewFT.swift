import SwiftUI

struct RootViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    @State private var showSplash = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashViewFT()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                                if !hasSeenOnboarding {
                                    showOnboarding = true
                                }
                            }
                        }
                    }
                    .zIndex(2)
            }
            
            if !showSplash {
                if showOnboarding {
                    OnboardingViewFT(showOnboarding: $showOnboarding)
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                        .onDisappear {
                            hasSeenOnboarding = true
                        }
                } else {
                    MainViewFT()
                        .transition(.opacity)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
