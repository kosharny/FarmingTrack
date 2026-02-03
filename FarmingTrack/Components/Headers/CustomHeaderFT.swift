import SwiftUI

struct CustomHeaderFT: View {
    let title: String
    let showBackButton: Bool
    let rightIcon: String?
    let rightAction: (() -> Void)?
    
    // Dependencies
    @EnvironmentObject var viewModel: MainViewModelFT
    @Environment(\.dismiss) var dismiss
    
    init(title: String, showBackButton: Bool = false, rightIcon: String? = nil, rightAction: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.rightIcon = rightIcon
        self.rightAction = rightAction
    }
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            } else {
                // Placeholder to balance
                Color.clear.frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(title.uppercased())
                .font(.title3)
                .fontWeight(.black)
                .tracking(2)
                .foregroundColor(Color.FT.textPrimary)
            
            Spacer()
            
            if let rightIcon = rightIcon, let rightAction = rightAction {
                Button(action: rightAction) {
                    Image(systemName: rightIcon)
                        .font(.title3)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(
            (Color.FT.backgroundColors(for: viewModel.currentTheme).first ?? Color.FT.backgroundStart)
                .opacity(0.8)
                .ignoresSafeArea()
                .blur(radius: 5)
        )
    }
}

#Preview {
    ZStack {
        let vm = MainViewModelFT()
        MainBackgroundFT()
            .environmentObject(vm)
        VStack {
            CustomHeaderFT(title: "Home", rightIcon: "gearshape.fill", rightAction: {})
                .environmentObject(vm)
            Spacer()
        }
    }
}
