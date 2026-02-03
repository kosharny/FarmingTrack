import SwiftUI

struct MainViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MainBackgroundFT()
            
            // Tab Content
            switch viewModel.selectedTab {
            case .home:
                HomeViewFT()
            case .journal:
                JournalViewFT()
            case .search:
                SearchViewFT()
            case .favorites:
                FavoritesViewFT()
            case .stats:
                StatsViewFT()
            }
            
            // Tab Bar
            if viewModel.showTabBar {
                CustomTabBarFT(selectedTab: $viewModel.selectedTab)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    MainViewFT()
        .environmentObject(MainViewModelFT())
}
