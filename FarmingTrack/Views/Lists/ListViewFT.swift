import SwiftUI

enum ListViewTypeFT {
    case articles
    case tasks
    
    var title: String {
        switch self {
        case .articles: return "All Articles"
        case .tasks: return "All Tasks"
        }
    }
}

struct ListViewFT: View {
    let type: ListViewTypeFT
    @EnvironmentObject var viewModel: MainViewModelFT
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: type.title, showBackButton: true)
                
                ScrollView {
                    VStack(spacing: 16) {
                        switch type {
                        case .articles:
                            ForEach(viewModel.articles) { article in
                                NavigationLink(value: AppRouteFT.article(article)) {
                                    ArticleRowFT(article: article)
                                }
                            }
                        case .tasks:
                            ForEach(viewModel.tasks) { task in
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
