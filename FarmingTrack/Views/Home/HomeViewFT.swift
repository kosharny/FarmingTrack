import SwiftUI

struct HomeViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                MainBackgroundFT()
                
                VStack(spacing: 0) {
                    CustomHeaderFT(title: "Farm Home", rightIcon: "gearshape.fill", rightAction: {
                        viewModel.navigationPath.append(AppRouteFT.settings)
                    })
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Banner / Update
                            // Banner / Update
                            GameCardFT(contentPadding: 0) {
                                ZStack {
                                    // Background Image
                                    Image("sunny_farm_background")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 160)
                                        .clipped()
                                        .overlay(Color.black.opacity(0.3)) // Dark overlay for text readability
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Welcome Back!")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            Text("Check your daily tasks.")
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                }
                                .frame(height: 160)
                            }
                            
                            // Categories - Navigation
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    // Removed "All" as requested
                                    ForEach(["Crops", "Livestock", "Machinery", "Water"], id: \.self) { cat in
                                        CategoryPillFT(icon: iconForCategory(cat), title: cat, isSelected: false) {
                                            viewModel.navigationPath.append(AppRouteFT.category(cat))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Featured Article
                            if let featured = viewModel.articles.first {
                                SectionHeaderFT(title: "Featured Article") {
                                    viewModel.navigationPath.append(AppRouteFT.articleList)
                                }
                                NavigationLink(value: AppRouteFT.article(featured)) {
                                    ArticleRowFT(article: featured)
                                }
                            }
                            
                            // Tasks List
                            SectionHeaderFT(title: "Today's Tasks") {
                                viewModel.navigationPath.append(AppRouteFT.taskList)
                            }
                            ForEach(viewModel.tasks.prefix(3)) { task in
                                NavigationLink(value: AppRouteFT.task(task)) {
                                    TaskRowFT(task: task)
                                }
                            }
                            
                            // Tools & Insights
                            SectionHeaderFT(title: "Tools & Insights")
                            
                            HStack(spacing: 15) {
                                NavigationLink(value: AppRouteFT.weather) {
                                    HomeInteractionCard(
                                        title: "Weather",
                                        subtitle: "Farming Schedule",
                                        icon: "calendar",
                                        color: Color.FT.primaryYellow
                                    )
                                }
                                .frame(maxWidth: .infinity)
                                
                                NavigationLink(value: AppRouteFT.market) {
                                    HomeInteractionCard(
                                        title: "Markets",
                                        subtitle: "Sales Advice",
                                        icon: "chart.bar.fill",
                                        color: Color.FT.farmGreen
                                    )
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .padding(.bottom, 80) // Space for TabBar
                    }
                }
            }
            .navigationDestination(for: AppRouteFT.self) { route in
                switch route {
                case .settings:
                    SettingsViewFT()
                        .toolbar(.hidden, for: .navigationBar)
                case .category(let category):
                    CategoryViewFT(category: category)
                        .toolbar(.hidden, for: .navigationBar)
                case .articleList:
                    ListViewFT(type: .articles)
                        .toolbar(.hidden, for: .navigationBar)
                case .taskList:
                    ListViewFT(type: .tasks)
                        .toolbar(.hidden, for: .navigationBar)
                case .article(let article):
                    DetailsViewFT(item: .article(article))
                        .toolbar(.hidden, for: .navigationBar)
                case .task(let task):
                    DetailsViewFT(item: .task(task))
                        .toolbar(.hidden, for: .navigationBar)
                case .weather:
                    WeatherViewFT()
                        .toolbar(.hidden, for: .navigationBar)
                case .market:
                    MarketViewFT()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
    }
    
    struct HomeInteractionCard: View {
        let title: String
        let subtitle: String
        let icon: String
        let color: Color
        
        var body: some View {
            GameCardFT {
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(color)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(Color.FT.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Crops": return "carrot.fill"
        case "Livestock": return "pawprint.fill"
        case "Machinery": return "wrench.and.screwdriver.fill"
        case "Water": return "drop.fill"
        default: return "leaf.fill"
        }
    }
}
