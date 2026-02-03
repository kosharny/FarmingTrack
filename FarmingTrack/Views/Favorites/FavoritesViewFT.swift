import SwiftUI

struct FavoritesViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    @State private var selectedFilter: String? = nil
    @State private var showSettings = false
    
    var favArticles: [ArticleModelFT] {
        let items = viewModel.articles.filter { viewModel.favoriteArticleIds.contains($0.id) }
        guard let filter = selectedFilter else { return items }
        return items.filter { $0.category == filter }
    }
    
    var favTasks: [TaskModelFT] {
        let items = viewModel.tasks.filter { viewModel.favoriteTaskIds.contains($0.id) }
        guard let filter = selectedFilter else { return items }
        return items.filter { $0.category == filter }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MainBackgroundFT()
                
                VStack(spacing: 0) {
                    CustomHeaderFT(title: "Favorites", rightIcon: "gearshape.fill", rightAction: {
                        showSettings = true
                    })
                    
                    FilterBarFT(selectedCategory: $selectedFilter, categories: ["Crops", "Livestock", "Machinery", "Water"])
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if favArticles.isEmpty && favTasks.isEmpty {
                                EmptyStateView(message: "Tap the heart icon on articles or tasks to save them here.")
                            } else {
                                if !favTasks.isEmpty {
                                    SectionHeaderFT(title: "Tasks")
                                    ForEach(favTasks) { task in
                                        NavigationLink(value: task) {
                                            TaskRowFT(task: task)
                                        }
                                    }
                                }
                                
                                if !favArticles.isEmpty {
                                    SectionHeaderFT(title: "Articles")
                                    ForEach(favArticles) { article in
                                        NavigationLink(value: article) {
                                            ArticleRowFT(article: article)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
            .navigationDestination(for: ArticleModelFT.self) { article in
                DetailsViewFT(item: .article(article))
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: TaskModelFT.self) { task in
                DetailsViewFT(item: .task(task))
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsViewFT()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
