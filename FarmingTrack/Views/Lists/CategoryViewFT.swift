import SwiftUI

struct CategoryViewFT: View {
    let category: String
    @EnvironmentObject var viewModel: MainViewModelFT
    
    var filteredArticles: [ArticleModelFT] {
        viewModel.articles.filter { $0.category == category }
    }
    
    var filteredTasks: [TaskModelFT] {
        viewModel.tasks.filter { $0.category == category }
    }
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: category, showBackButton: true)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if filteredArticles.isEmpty && filteredTasks.isEmpty {
                            EmptyStateView(message: "No content found for \(category).")
                        }
                        
                        if !filteredArticles.isEmpty {
                            SectionHeaderFT(title: "Articles")
                            ForEach(filteredArticles) { article in
                                NavigationLink(value: AppRouteFT.article(article)) {
                                    ArticleRowFT(article: article)
                                }
                            }
                        }
                        
                        if !filteredTasks.isEmpty {
                            SectionHeaderFT(title: "Tasks")
                            ForEach(filteredTasks) { task in
                                NavigationLink(value: AppRouteFT.task(task)) {
                                    TaskRowFT(task: task)
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
