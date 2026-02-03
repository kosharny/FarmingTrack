import SwiftUI

enum DetailItemTypeFT: Hashable {
    case article(ArticleModelFT)
    case task(TaskModelFT)
}

struct DetailsViewFT: View {
    let item: DetailItemTypeFT
    @EnvironmentObject var viewModel: MainViewModelFT
    @State private var showTaskExecution = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                switch item {
                case .article(let article):
                    contentHeader(title: "Article")
                    ScrollView {
                        articleContent(article)
                    }
                case .task(let task):
                    contentHeader(title: "Task")
                    ScrollView {
                        taskContent(task)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showTaskExecution) {
            if case .task(let task) = item {
                TaskExecutionViewFT(task: task)
            }
        }
        .onAppear { viewModel.showTabBar = false }
        .onDisappear { viewModel.showTabBar = true }
    }
    
    @ViewBuilder
    private func contentHeader(title: String) -> some View {
        CustomHeaderFT(title: title, showBackButton: true)
    }
    
    @ViewBuilder
    private func articleContent(_ article: ArticleModelFT) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Hero Image Area
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(article.category.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.FT.primaryYellow)
                    Spacer()
                    Button(action: { viewModel.toggleFavorite(article) }) {
                        Image(systemName: viewModel.favoriteArticleIds.contains(article.id) ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(Color.FT.accentRed)
                    }
                }
                
                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Text(article.subtitle)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                
                Divider().background(Color.white.opacity(0.2))
                
                // Rich Text Visual Breakdown
                ForEach(article.content.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                    Text(paragraph)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(Color.FT.textSecondary)
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                }
                
                Spacer().frame(height: 30)
                
                if viewModel.readArticleIds.contains(article.id) {
                     HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.FT.farmGreen)
                        Text("Read")
                            .foregroundColor(Color.FT.farmGreen)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                } else {
                    PrimaryButtonFT(title: "Mark as Read", icon: "book.fill", color: Color.FT.farmGreen) {
                        viewModel.markArticleRead(article)
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func taskContent(_ task: TaskModelFT) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(task.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    BadgeFT(text: task.difficulty, color: Color.FT.accentRed)
                    BadgeFT(text: "\(task.steps.count) STEPS", color: Color.FT.farmGreen)
                    Spacer()
                    Button(action: { viewModel.toggleFavorite(task) }) {
                        Image(systemName: viewModel.favoriteTaskIds.contains(task.id) ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(Color.FT.accentRed)
                    }
                }
                
                Text(task.title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Text(task.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Reward: \(task.rewardPoints) XP")
                    .font(.headline)
                    .foregroundColor(Color.FT.primaryYellow)
                
                Divider().background(Color.white.opacity(0.2))
                
                // Steps Preview
                ForEach(Array(task.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top) {
                        Text("\(index + 1)")
                            .font(.headline)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading) {
                            Text(step.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(step.description)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Spacer().frame(height: 40)
                
                if viewModel.completedTaskIds.contains(task.id) {
                    PrimaryButtonFT(title: "Completed", icon: "checkmark.seal.fill", color: Color.gray) {
                        // Action disabled essentially, or maybe show stats
                    }
                    .disabled(true)
                    .opacity(0.6)
                } else {
                    PrimaryButtonFT(title: "Start Task", icon: "play.fill", action: {
                        showTaskExecution = true
                    })
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
    }
}
