import SwiftUI

struct MarketViewFT: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelFT
    
    let prices = [
        MarketPrice(name: "Wheat", price: "$320.50", unit: "tonne", change: "+1.2%", isUp: true),
        MarketPrice(name: "Corn", price: "$215.10", unit: "tonne", change: "-0.5%", isUp: false),
        MarketPrice(name: "Soybeans", price: "$510.80", unit: "tonne", change: "+2.1%", isUp: true),
        MarketPrice(name: "Canola", price: "$645.30", unit: "tonne", change: "+0.8%", isUp: true),
        MarketPrice(name: "Barley", price: "$195.00", unit: "tonne", change: "-1.1%", isUp: false)
    ]
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: "Market Prices", leftIcon: "chevron.left", leftAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Market Summary
                        GameCardFT {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Market Overview")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Overall trend is bullish today")
                                        .font(.subheadline)
                                        .foregroundColor(Color.FT.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.title)
                                    .foregroundColor(Color.FT.farmGreen)
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        // Price List
                        ForEach(prices) { item in
                            GameCardFT {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("per \(item.unit)")
                                            .font(.caption)
                                            .foregroundColor(Color.FT.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text(item.price)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        HStack(spacing: 4) {
                                            Image(systemName: item.isUp ? "arrow.up.right" : "arrow.down.right")
                                            Text(item.change)
                                        }
                                        .font(.caption)
                                        .foregroundColor(item.isUp ? Color.FT.farmGreen : Color.FT.accentRed)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Last Updated
                        Text("Last updated: February 4, 12:15 PM")
                            .font(.caption)
                            .foregroundColor(Color.FT.textSecondary)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct MarketPrice: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let unit: String
    let change: String
    let isUp: Bool
}

#Preview {
    MarketViewFT()
        .environmentObject(MainViewModelFT())
}
