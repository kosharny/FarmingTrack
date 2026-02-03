import Foundation

enum AppRouteFT: Hashable {
    case settings
    case category(String)
    case articleList
    case taskList
    case article(ArticleModelFT)
    case task(TaskModelFT)
}
