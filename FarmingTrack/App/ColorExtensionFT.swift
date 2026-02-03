import SwiftUI

extension Color {
    struct FT {
        static let backgroundStart = Color(hex: "0F2027")
        static let backgroundEnd = Color(hex: "203A43")
        
        static let primaryYellow = Color(hex: "F4D03F")
        static let farmGreen = Color(hex: "58D68D")
        static let softOrange = Color(hex: "EB984E")
        static let accentRed = Color(hex: "E74C3C")
        
        static let cardBackground = Color.white.opacity(0.1)
        static let cardBorder = Color.white.opacity(0.2)
        
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        
        // Theme Gradients
        static func backgroundColors(for theme: MainViewModelFT.ThemeFT) -> [Color] {
            switch theme {
            case .classic:
                return [Color(hex: "0F2027"), Color(hex: "203A43")]
            case .lush:
                return [Color(hex: "134E5E"), Color(hex: "71B280")]
            case .sunset:
                return [Color(hex: "4B1248"), Color(hex: "F0C27B")]
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct MainBackgroundFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    var overrideTheme: MainViewModelFT.ThemeFT? = nil
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: Color.FT.backgroundColors(for: overrideTheme ?? viewModel.currentTheme)),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
