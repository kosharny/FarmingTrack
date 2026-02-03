import SwiftUI

struct CustomTabBarFT: View {
    @Binding var selectedTab: MainViewModelFT.TabFT
    @EnvironmentObject var viewModel: MainViewModelFT
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house.fill", title: "Home", tab: .home, selectedTab: $selectedTab)
            TabBarButton(icon: "book.fill", title: "Journal", tab: .journal, selectedTab: $selectedTab)
            TabBarButton(icon: "magnifyingglass", title: "Search", tab: .search, selectedTab: $selectedTab)
            TabBarButton(icon: "star.fill", title: "Favs", tab: .favorites, selectedTab: $selectedTab)
            TabBarButton(icon: "chart.bar.fill", title: "Stats", tab: .stats, selectedTab: $selectedTab)
        }
        .padding()
        .background(
            Capsule()
                .fill((Color.FT.backgroundColors(for: viewModel.currentTheme).first ?? Color.FT.backgroundStart).opacity(0.95))
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let tab: MainViewModelFT.TabFT
    @Binding var selectedTab: MainViewModelFT.TabFT
    
    var isSelected: Bool { selectedTab == tab }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                
                if isSelected {
                    Circle()
                        .fill(Color.FT.primaryYellow)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? Color.FT.primaryYellow : Color.white.opacity(0.5))
        }
    }
}

#Preview {
    ZStack {
        let vm = MainViewModelFT()
        MainBackgroundFT()
            .environmentObject(vm)
        VStack {
            Spacer()
            CustomTabBarFT(selectedTab: .constant(.home))
                .environmentObject(vm)
        }
    }
}
