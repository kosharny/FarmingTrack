import SwiftUI

struct WeatherViewFT: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelFT
    
    let forecast = [
        WeatherDay(day: "Mon", icon: "sun.max.fill", temp: "24°", high: "26°", low: "18°"),
        WeatherDay(day: "Tue", icon: "cloud.fill", temp: "21°", high: "23°", low: "16°"),
        WeatherDay(day: "Wed", icon: "cloud.rain.fill", temp: "18°", high: "20°", low: "15°"),
        WeatherDay(day: "Thu", icon: "cloud.sun.fill", temp: "22°", high: "24°", low: "17°"),
        WeatherDay(day: "Fri", icon: "sun.max.fill", temp: "26°", high: "28°", low: "20°")
    ]
    
    var body: some View {
        ZStack {
            MainBackgroundFT()
            
            VStack(spacing: 0) {
                CustomHeaderFT(title: "Weather Forecast", leftIcon: "chevron.left", leftAction: {
                    dismiss()
                })
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Current Weather Hero
                        VStack(spacing: 10) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 80))
                                .foregroundColor(Color.FT.primaryYellow)
                                .shadow(color: Color.FT.primaryYellow.opacity(0.5), radius: 15)
                            
                            Text("24°C")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Sunny - Kyiv, Ukraine")
                                .font(.title3)
                                .foregroundColor(Color.FT.textSecondary)
                        }
                        .padding(.top, 30)
                        
                        // Today's Stats
                        HStack(spacing: 20) {
                            StatBox(icon: "humidity.fill", value: "45%", label: "Humidity")
                            StatBox(icon: "wind", value: "12 km/h", label: "Wind")
                            StatBox(icon: "drop.fill", value: "10%", label: "Precip")
                        }
                        .padding(.horizontal)
                        
                        // 5-Day Forecast
                        VStack(alignment: .leading, spacing: 15) {
                            Text("5-Day Forecast")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            ForEach(forecast) { day in
                                GameCardFT {
                                    HStack {
                                        Text(day.day)
                                            .font(.headline)
                                            .frame(width: 50, alignment: .leading)
                                        
                                        Spacer()
                                        
                                        Image(systemName: day.icon)
                                            .foregroundColor(day.icon.contains("sun") ? Color.FT.primaryYellow : .white)
                                            .font(.title2)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 10) {
                                            Text(day.high)
                                                .fontWeight(.bold)
                                            Text(day.low)
                                                .foregroundColor(Color.FT.textSecondary)
                                        }
                                        .frame(width: 80, alignment: .trailing)
                                    }
                                    .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct StatBox: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color.FT.farmGreen)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(Color.FT.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.FT.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.FT.cardBorder, lineWidth: 1)
        )
    }
}

struct WeatherDay: Identifiable {
    let id = UUID()
    let day: String
    let icon: String
    let temp: String
    let high: String
    let low: String
}

#Preview {
    WeatherViewFT()
        .environmentObject(MainViewModelFT())
}
