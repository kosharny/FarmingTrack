import SwiftUI

struct MarketViewFT: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelFT
    
    // Sales Recommendations Data
    let salesRecommendations = [
        SalesRecommendation(crop: "Wheat", action: "Sell", reasoning: "Global supply shortage driving prices up.", profitPotential: "High", icon: "arrow.up.forward.circle.fill"),
        SalesRecommendation(crop: "Corn", action: "Hold", reasoning: "Harvest surplus expected to clear next month.", profitPotential: "Moderate", icon: "hand.raised.fill"),
        SalesRecommendation(crop: "Soybeans", action: "Sell", reasoning: "Strong export demand this week.", profitPotential: "High", icon: "arrow.up.forward.circle.fill")
    ]
    
    let marketGuides = [
        MarketGuide(title: "Understanding Trends", summary: "How to read market charts effectively.", readTime: "5 min", image: "chart.xyaxis.line"),
        MarketGuide(title: "Storage & Timing", summary: "When to sell vs. store your grain.", readTime: "7 min", image: "building.2.fill"),
        MarketGuide(title: "Global Impact", summary: "How global events affect local prices.", readTime: "4 min", image: "globe")
    ]
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: "Market Prices", showBackButton: true)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Market Overview
                        GameCardFT {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Market Overview")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Market is bullish")
                                            .font(.subheadline)
                                            .foregroundColor(Color.FT.farmGreen)
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.title)
                                        .foregroundColor(Color.FT.farmGreen)
                                        .padding(10)
                                        .background(Color.FT.farmGreen.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                
                                // Dummy Chart Visual
                                HStack(alignment: .bottom, spacing: 8) {
                                    ForEach(0..<20) { i in
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.FT.farmGreen.opacity(Double(i)/20.0 + 0.2))
                                            .frame(height: CGFloat.random(in: 20...60))
                                    }
                                }
                                .frame(height: 60)
                            }
                            .padding()
                        }
                        .padding(.top)
                        
                        // Market Insights
                        VStack(alignment: .leading, spacing: 15) {
                            SectionHeaderFT(title: "Market Insights")
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(marketGuides) { guide in
                                        MarketGuideCard(guide: guide)
                                    }
                                }
                            }
                        }
                        
                        // Sales Advice List
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Selling Advice")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            ForEach(salesRecommendations) { item in
                                GameCardFT {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(item.crop)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                
                                                Spacer()
                                                
                                                Text(item.action.uppercased())
                                                    .font(.caption2)
                                                    .fontWeight(.black)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 5)
                                                    .background(item.action == "Sell" ? Color.FT.farmGreen : Color.FT.accentRed)
                                                    .cornerRadius(8)
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Text(item.reasoning)
                                                .font(.caption)
                                                .foregroundColor(Color.FT.textSecondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            Text("Profit Potential: \(item.profitPotential)")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.FT.primaryYellow)
                                                .padding(.top, 2)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SalesRecommendation: Identifiable {
    let id = UUID()
    let crop: String
    let action: String
    let reasoning: String
    let profitPotential: String
    let icon: String
}

struct MarketGuide: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let readTime: String
    let image: String
}

struct MarketGuideCard: View {
    let guide: MarketGuide
    
    var body: some View {
        GameCardFT {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: guide.image)
                        .font(.title2)
                        .foregroundColor(Color.FT.primaryYellow)
                    Spacer()
                    Text(guide.readTime)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(guide.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(guide.summary)
                        .font(.caption)
                        .foregroundColor(Color.FT.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(width: 160, height: 120)
            .padding(12)
        }
    }
}

#Preview {
    MarketViewFT()
        .environmentObject(MainViewModelFT())
}
