import SwiftUI
import StoreKit

struct SettingsViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    @Environment(\.dismiss) var dismiss
    @State private var showPaywall = false
    @State private var selectedThemeToBuy: MainViewModelFT.ThemeFT?
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: "Settings", showBackButton: true) // Back button will pop nav stack
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Section: Themes
                        themesSection
                        purchasesSection
                        aboutSection
                    }
                    .padding()
                    Spacer(minLength: 100)
                }
            }
            .navigationBarBackButtonHidden(true) // We use custom header
            .sheet(item: $selectedThemeToBuy) { theme in
                PaywallViewFT(
                    storeManager: viewModel.storeManager,
                    theme: theme
                )
                .environmentObject(viewModel)
            }
            .task {
                await viewModel.storeManager.loadProducts()
            }
        }
    }
}

private extension SettingsViewFT {

    var themesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderFT(title: "Themes")

            ForEach(MainViewModelFT.ThemeFT.allCases) { theme in
                ThemeRow(
                    theme: theme,
                    price: price(for: theme),
                    isSelected: viewModel.currentTheme == theme,
                    isLocked: isLocked(theme)
                ) {
                    handleThemeTap(theme)
                }
            }
        }
    }
}

private extension SettingsViewFT {

    var purchasesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderFT(title: "Purchases")

            Button {
                Task {
                    await viewModel.storeManager.restore()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Restore Purchases")
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
            }
        }
    }
}

private extension SettingsViewFT {

    var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderFT(title: "App Info")

            NavigationLink {
                AboutViewFT()
            } label: {
                HStack {
                    Image(systemName: "info.circle")
                    Text("About Farming Track")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .foregroundColor(.white)
            }
        }
    }
}

private extension SettingsViewFT {

    func handleThemeTap(_ theme: MainViewModelFT.ThemeFT) {
        if viewModel.canUse(theme) {
            viewModel.selectTheme(theme)
        } else {
            selectedThemeToBuy = theme
        }
    }

    func isLocked(_ theme: MainViewModelFT.ThemeFT) -> Bool {
        !viewModel.canUse(theme)
    }

    func price(for theme: MainViewModelFT.ThemeFT) -> String? {
        guard let id = theme.productID else { return "Free" }
        return viewModel.storeManager
            .product(for: id)?
            .displayPrice
    }
}

struct ThemeRow: View {

    let theme: MainViewModelFT.ThemeFT
    let price: String?
    let isSelected: Bool
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(themeColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                    )

                VStack(alignment: .leading) {
                    Text(theme.displayName)
                        .font(.headline)
                        .foregroundColor(isSelected ? Color.FT.primaryYellow : .white)

                    if let price, isLocked {
                        Text(price)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()

                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white.opacity(0.5))

                    Text("PRO")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(4)
                        .background(Color.FT.softOrange)
                        .cornerRadius(4)
                        .foregroundColor(.white)
                }

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.FT.primaryYellow)
                }
            }
            .padding()
            .background(Color.white.opacity(isSelected ? 0.15 : 0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.FT.primaryYellow : .clear, lineWidth: 1)
            )
        }
    }

    private var themeColor: Color {
        switch theme {
        case .classic: return Color.FT.farmGreen
        case .lush: return .green.opacity(0.5)
        case .sunset: return .orange.opacity(0.5)
        }
    }
}
