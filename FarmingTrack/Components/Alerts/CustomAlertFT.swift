import SwiftUI

struct CustomAlertFT: View {
    let title: String
    let message: String
    let primaryButton: AlertButtonFT
    let secondaryButton: AlertButtonFT?
    
    init(title: String, 
         message: String, 
         primaryButton: AlertButtonFT, 
         secondaryButton: AlertButtonFT? = nil) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                GameCardFT {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Text(title)
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(message)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        
                        HStack(spacing: 16) {
                            if let secondaryButton = secondaryButton {
                                Button(action: secondaryButton.action) {
                                    Text(secondaryButton.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white.opacity(0.6))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white.opacity(0.1))
                                        .cornerRadius(16)
                                }
                            }
                            
                            PrimaryButtonFT(
                                title: primaryButton.title,
                                icon: primaryButton.icon,
                                color: primaryButton.color,
                                action: primaryButton.action
                            )
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 30)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct AlertButtonFT {
    let title: String
    let icon: String?
    let color: Color
    let action: () -> Void
    
    init(title: String, icon: String? = nil, color: Color = Color.FT.farmGreen, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
}

#Preview {
    CustomAlertFT(
        title: "Confirm Purchase",
        message: "Would you like to unlock the Lush theme for $1.99?",
        primaryButton: AlertButtonFT(title: "Confirm", icon: "checkmark", action: {}),
        secondaryButton: AlertButtonFT(title: "Cancel", action: {})
    )
}
