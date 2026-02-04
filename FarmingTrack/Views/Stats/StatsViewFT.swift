import SwiftUI
import Charts

struct StatsViewFT: View {
    @EnvironmentObject var viewModel: MainViewModelFT
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                MainBackgroundFT()
                
                VStack(spacing: 0) {
                    CustomHeaderFT(title: "Statistics", rightIcon: "gearshape.fill", rightAction: {
                       showSettings = true
                    })
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Total XP Card
                            GameCardFT {
                                VStack {
                                    Text("TOTAL XP")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("\(viewModel.totalXP)")
                                        .font(.system(size: 48, weight: .black))
                                        .foregroundColor(Color.FT.primaryYellow)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            
                            // Grid stats
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                StatsStatBox(title: "Tasks Done", value: "\(viewModel.completedTasksCount)", icon: "checkmark.seal.fill", color: Color.FT.farmGreen)
                                StatsStatBox(title: "Articles Read", value: "\(viewModel.readArticlesCount)", icon: "book.fill", color: Color.FT.softOrange)
                                StatsStatBox(title: "Favorites", value: "\(viewModel.favoriteArticleIds.count + viewModel.favoriteTaskIds.count)", icon: "heart.fill", color: Color.FT.accentRed)
                                StatsStatBox(title: "Level", value: "\(viewModel.totalXP / 500 + 1)", icon: "crown.fill", color: Color.FT.primaryYellow)
                            }
                            
                            // Activity Graph
                            SectionHeaderFT(title: "User Activity")
                            GameCardFT {
                                VStack(alignment: .leading) {
                                    Text("Daily Activity (XP)")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    // Simple custom bar chart since Charts might not be fully configured or limited in this context
                                    // But implementing a simple visual geometry reader based chart
                                    HStack(alignment: .bottom, spacing: 12) {
                                        ForEach(0..<7) { day in
                                            VStack {
                                                Spacer()
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(day == 6 ? Color.FT.primaryYellow : Color.white.opacity(0.2))
                                                    .frame(height: CGFloat([20, 45, 30, 60, 25, 50, 80][day])) // Dummy data for visual proof
                                                Text(["M", "T", "W", "T", "F", "S", "S"][day])
                                                    .font(.caption2)
                                                    .foregroundColor(.white.opacity(0.5))
                                            }
                                        }
                                    }
                                    .frame(height: 150)
                                }
                                .padding()
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsViewFT()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

private struct StatsStatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        GameCardFT {
            VStack(spacing: 12) {
                Circle()
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: icon).foregroundColor(color))
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(title.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
