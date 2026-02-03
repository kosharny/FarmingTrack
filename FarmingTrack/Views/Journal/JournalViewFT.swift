import SwiftUI

struct JournalViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    @State private var selectedFilter: String? = nil
    @State private var showSettings = false
    
    var filteredCompletedTasks: [TaskModelFT] {
        let items = viewModel.tasks.filter { viewModel.completedTaskIds.contains($0.id) }
        guard let filter = selectedFilter else { return items }
        return items.filter { $0.category == filter }
    }
    
    var filteredReadArticles: [ArticleModelFT] {
        let items = viewModel.articles.filter { viewModel.readArticleIds.contains($0.id) }
        guard let filter = selectedFilter else { return items }
        return items.filter { $0.category == filter }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MainBackgroundFT()
                
                VStack(spacing: 0) {
                    CustomHeaderFT(title: "Journal", rightIcon: "gearshape.fill", rightAction: {
                        showSettings = true
                    })
                    
                    FilterBarFT(selectedCategory: $selectedFilter, categories: ["Crops", "Livestock", "Machinery", "Water", "Techniques"])
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            if filteredCompletedTasks.isEmpty && filteredReadArticles.isEmpty {
                                EmptyStateView(message: "No entries found for this filter.")
                            }
                            
                            if !filteredCompletedTasks.isEmpty {
                                SectionHeaderFT(title: "Completed Tasks (\(filteredCompletedTasks.count))")
                                ForEach(filteredCompletedTasks) { task in
                                    NavigationLink(value: task) {
                                        TaskRowFT(task: task)
                                    }
                                }
                            }
                            
                            if !filteredReadArticles.isEmpty {
                                SectionHeaderFT(title: "Read Articles (\(filteredReadArticles.count))")
                                ForEach(filteredReadArticles) { article in
                                    NavigationLink(value: article) {
                                        ArticleRowFT(article: article)
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
            .navigationDestination(for: TaskModelFT.self) { task in
                DetailsViewFT(item: .task(task))
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: ArticleModelFT.self) { article in
                DetailsViewFT(item: .article(article))
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsViewFT()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
