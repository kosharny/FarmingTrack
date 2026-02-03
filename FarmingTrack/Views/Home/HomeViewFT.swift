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
                            GameCardFT {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Welcome Back!")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text("Check your daily tasks.")
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    Spacer()
                                    Image(systemName: "sun.max.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color.FT.primaryYellow)
                                }
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
                }
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
