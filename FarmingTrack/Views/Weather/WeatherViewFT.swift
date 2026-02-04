import SwiftUI

struct WeatherViewFT: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelFT
    
    // Timeline Data
    let timelineEvents = [
        TimelineEvent(month: "Feb", day: "04", title: "Soil Preparation", type: .preparation, description: "Check soil pH and moisture levels.", status: "In Progress"),
        TimelineEvent(month: "Feb", day: "15", title: "Order Seeds", type: .preparation, description: "Finalize corn and soybean seed orders.", status: "Upcoming"),
        TimelineEvent(month: "Mar", day: "01", title: "Machine Maint.", type: .maintenance, description: "Inspect planters and tractors.", status: "Upcoming"),
        TimelineEvent(month: "Apr", day: "10", title: "Plant Corn", type: .plant, description: "Optimal window begins for corn.", status: "Upcoming"),
        TimelineEvent(month: "May", day: "05", title: "Plant Soybeans", type: .plant, description: "Start planting if soil temp > 55°F.", status: "Upcoming"),
        TimelineEvent(month: "Sep", day: "20", title: "Harvest Corn", type: .harvest, description: "Begin harvest when moisture < 25%.", status: "Upcoming")
    ]
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: "Farming Schedule", showBackButton: true)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(timelineEvents.enumerated()), id: \.element.id) { index, event in
                            TimelineRowFT(event: event, isLast: index == timelineEvents.count - 1)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 80)
                }
            }
        }
    }
}

// MARK: - Data Models

struct TimelineEvent: Identifiable {
    let id = UUID()
    let month: String
    let day: String
    let title: String
    let type: EventType
    let description: String
    let status: String
}

enum EventType {
    case plant, harvest, preparation, maintenance
    
    var color: Color {
        switch self {
        case .plant: return Color.FT.farmGreen
        case .harvest: return Color.FT.primaryYellow
        case .preparation: return Color.cyan
        case .maintenance: return Color.gray
        }
    }
    
    var icon: String {
        switch self {
        case .plant: return "leaf.fill"
        case .harvest: return "cart.fill"
        case .preparation: return "list.clipboard.fill"
        case .maintenance: return "wrench.and.screwdriver.fill"
        }
    }
}

// MARK: - Components

struct TimelineRowFT: View {
    let event: TimelineEvent
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Date Column
            VStack(spacing: 4) {
                Text(event.month.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.FT.textSecondary)
                Text(event.day)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.white)
            }
            .frame(width: 50)
            .padding(.top, 4)
            
            // Timeline Line
            VStack(spacing: 0) {
                Circle()
                    .fill(event.type.color)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 4)
                    )
                
                if !isLast {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .padding(.top, 12)
            
            // Event Card
            GameCardFT {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: event.type.icon)
                            .foregroundColor(event.type.color)
                        Text(event.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Text(event.description)
                        .font(.subheadline)
                        .foregroundColor(Color.FT.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }
}

#Preview {
    WeatherViewFT()
        .environmentObject(MainViewModelFT())
}
