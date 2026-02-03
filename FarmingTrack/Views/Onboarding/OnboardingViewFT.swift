import SwiftUI

struct OnboardingViewFT: View {
    @Binding var showOnboarding: Bool
    @State private var currentTab = 0
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            TabView(selection: $currentTab) {
                // Intro - Sunny Farm
                OnboardingSlide(imageName: "sunny_farm_background", title: "Welcome to Farming Track", description: "Your personal guide to managing a thriving farm. Start your journey today.")
                    .tag(0)
                
                // Tasks - Golden Wheat / Checklist
                OnboardingSlide(imageName: "golden_wheat", title: "Track Tasks", description: "Complete daily tasks, gain XP, and level up your farming skills one step at a time.")
                    .tag(1)
                
                // Machinery/Progress - Tractor
                OnboardingSlide(imageName: "green_tractor", title: "Learn & Grow", description: "Read expert articles and discover techniques for better yields.")
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        withAnimation {
                            showOnboarding = false
                        }
                    }
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 40)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                if currentTab == 2 {
                    PrimaryButtonFT(title: "Get Started", icon: "arrow.right", action: {
                        withAnimation {
                            showOnboarding = false
                        }
                    })
                } else {
                    PrimaryButtonFT(title: "Next", icon: "chevron.right", action: {
                        withAnimation {
                            currentTab += 1
                        }
                    })
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
    }
}

struct OnboardingSlide: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            // Using asset image instead of system icon
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding()
                // Fallback for dev if asset missing
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                )
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}
