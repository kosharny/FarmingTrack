import SwiftUI
import Combine

@MainActor
class MainViewModelFT: ObservableObject {
    // MARK: - Data
    @Published var articles: [ArticleModelFT] = []
    @Published var tasks: [TaskModelFT] = []
    
    // MARK: - User Progress
    @Published var completedTaskIds: Set<String> = []
    @Published var readArticleIds: Set<String> = []
    @Published var favoriteArticleIds: Set<String> = []
    @Published var favoriteTaskIds: Set<String> = []
    @Published var totalXP: Int = 0
    
    // MARK: - Settings
    @Published var currentTheme: ThemeFT = .classic
    
    // MARK: - State
    @Published var selectedTab: TabFT = .home
    @Published var showSettings = false // Keeping for legacy, but we will use nav dest mainly
    @Published var showTabBar = true
    @Published var navigationPath = [AppRouteFT]() // Simple path for now
    
    let storeManager: StoreManagerFT
    
    private let fileManager = FileManager.default
    
    enum TabFT: String {
         case home, journal, search, favorites, stats
    }
    
    enum ThemeFT: String, CaseIterable, Identifiable {
        case classic, lush, sunset
        var id: String { rawValue }
        
        var displayName: String {
            switch self {
            case .classic: return "Classic Farm"
            case .lush: return "Deep Green"
            case .sunset: return "Golden Hour"
            }
        }
        
        var productID: String? {
            switch self {
            case .classic: return nil
            case .lush: return "premium_theme_lush"
            case .sunset: return "premium_theme_sunset"
            }
        }
    }

    init() {
        self.storeManager = StoreManagerFT(
            productIDs: ThemeFT.allCases.compactMap { $0.productID }
        )
        
        loadData()
        loadPersistence()
    }
    
    // MARK: - Data Loading
    private func loadData() {
        self.articles = loadJSON(filename: "articlesFT")
        self.tasks = loadJSON(filename: "tasksFT")
    }
    
    private func loadJSON<T: Decodable>(filename: String) -> [T] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename).json in bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: data)
        } catch {
            print("Failed to decode \(filename).json: \(error)")
            return []
        }
    }
    
    // MARK: - Persistence
    private func loadPersistence() {
        let defaults = UserDefaults.standard
        if let savedTasks = defaults.stringArray(forKey: "completedTaskIds") {
            completedTaskIds = Set(savedTasks)
        }
        if let savedArticles = defaults.stringArray(forKey: "readArticleIds") {
            readArticleIds = Set(savedArticles)
        }
        if let savedFavs = defaults.stringArray(forKey: "favoriteArticleIds") {
            favoriteArticleIds = Set(savedFavs)
        }
        if let savedFavTasks = defaults.stringArray(forKey: "favoriteTaskIds") {
            favoriteTaskIds = Set(savedFavTasks)
        }
        totalXP = defaults.integer(forKey: "totalXP")
        
        if let themeName = defaults.string(forKey: "currentTheme"), let theme = ThemeFT(rawValue: themeName) {
            currentTheme = theme
        }
    }
    
    private func savePersistence() {
        let defaults = UserDefaults.standard
        defaults.set(Array(completedTaskIds), forKey: "completedTaskIds")
        defaults.set(Array(readArticleIds), forKey: "readArticleIds")
        defaults.set(Array(favoriteArticleIds), forKey: "favoriteArticleIds")
        defaults.set(Array(favoriteTaskIds), forKey: "favoriteTaskIds")
        defaults.set(totalXP, forKey: "totalXP")
        defaults.set(currentTheme.rawValue, forKey: "currentTheme")
    }
    
    // MARK: - Actions
    func completeTask(_ task: TaskModelFT) {
        guard !completedTaskIds.contains(task.id) else { return }
        completedTaskIds.insert(task.id)
        totalXP += task.rewardPoints
        savePersistence()
    }
    
    func markArticleRead(_ article: ArticleModelFT) {
        if !readArticleIds.contains(article.id) {
            readArticleIds.insert(article.id)
            totalXP += 10 // Small XP for reading
            savePersistence()
        }
    }
    
    func toggleFavorite(_ article: ArticleModelFT) {
        if favoriteArticleIds.contains(article.id) {
            favoriteArticleIds.remove(article.id)
        } else {
            favoriteArticleIds.insert(article.id)
        }
        savePersistence()
    }
    
    func toggleFavorite(_ task: TaskModelFT) {
        if favoriteTaskIds.contains(task.id) {
            favoriteTaskIds.remove(task.id)
        } else {
            favoriteTaskIds.insert(task.id)
        }
        savePersistence()
    }
    
    func setTheme(_ theme: ThemeFT) {
        currentTheme = theme
        savePersistence()
    }
    
    // MARK: - Computeds
    var completedTasksCount: Int { completedTaskIds.count }
    var readArticlesCount: Int { readArticleIds.count }
    
    func getTask(id: String) -> TaskModelFT? {
        tasks.first { $0.id == id }
    }
    
    func getArticle(id: String) -> ArticleModelFT? {
        articles.first { $0.id == id }
    }
    
    func selectTheme(_ theme: ThemeFT) {
        guard canUse(theme) else { return }
        currentTheme = theme
        savePersistence()
    }
    
    func canUse(_ theme: ThemeFT) -> Bool {
        guard let id = theme.productID else { return true }
        return storeManager.isPurchased(id)
    }
}
