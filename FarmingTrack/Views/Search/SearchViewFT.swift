import SwiftUI

struct SearchViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    @State private var searchText = ""
    @State private var searchType: ListViewTypeFT = .articles
    @State private var selectedCategory: String? = nil
    @State private var showSettings = false
    
    var filteredArticles: [ArticleModelFT] {
        var items = viewModel.articles
        if !searchText.isEmpty {
            items = items.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.category.localizedCaseInsensitiveContains(searchText) }
        }
        guard let cat = selectedCategory else { return items }
        return items.filter { $0.category == cat }
    }
    
    var filteredTasks: [TaskModelFT] {
        var items = viewModel.tasks
        if !searchText.isEmpty {
            items = items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        guard let cat = selectedCategory else { return items }
        return items.filter { $0.category == cat }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MainBackgroundFT()
                
                VStack(spacing: 0) {
                    CustomHeaderFT(title: "Search", rightIcon: "gearshape.fill", rightAction: {
                        showSettings = true
                    })
                    
                    VStack(spacing: 16) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.5))
                            TextField("Search...", text: $searchText)
                                .foregroundColor(.white)
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Segmented Picker
                        Picker("Type", selection: $searchType) {
                            Text("Articles").tag(ListViewTypeFT.articles)
                            Text("Tasks").tag(ListViewTypeFT.tasks)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .colorScheme(.dark)
                        
                        // Category Filters (Added in Iteration 3)
                        FilterBarFT(selectedCategory: $selectedCategory, categories: ["Crops", "Livestock", "Machinery", "Water", "Techniques"])
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if searchType == .articles {
                                if filteredArticles.isEmpty {
                                    EmptyStateView(message: "No articles found.")
                                } else {
                                    ForEach(filteredArticles) { article in
                                        NavigationLink(value: AppRouteFT.article(article)) {
                                            ArticleRowFT(article: article)
                                        }
                                    }
                                }
                            } else {
                                if filteredTasks.isEmpty {
                                    EmptyStateView(message: "No tasks found.")
                                } else {
                                    ForEach(filteredTasks) { task in
                                        NavigationLink(value: AppRouteFT.task(task)) {
                                            TaskRowFT(task: task)
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
            .navigationDestination(isPresented: $showSettings) {
                SettingsViewFT()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
