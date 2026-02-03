import SwiftUI

struct PrimaryButtonFT: View {
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
    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .buttonStyle(PrimaryButtonStyleFT(color: color))
    }
}

struct PrimaryButtonStyleFT: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color)
                    
                    // Glossy shine effect
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .blur(radius: 1)
                }
            )
            .foregroundColor(.white)
            .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        MainBackgroundFT()
        VStack {
            PrimaryButtonFT(title: "Start Task", icon: "play.fill", action: {})
            PrimaryButtonFT(title: "Buy for $1.99", icon: "lock.fill", color: Color.FT.softOrange, action: {})
        }
        .padding()
    }
}
