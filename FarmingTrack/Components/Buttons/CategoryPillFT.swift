import SwiftUI

struct CategoryPillFT: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            // Use prominent yellow if selected, otherwise farm green
            // For navigation pills (Home), we might always want green unless we track selection, 
            // but the usage in Home passed isSelected: false effectively making them buttons.
            .background(isSelected ? Color.FT.primaryYellow : Color.FT.farmGreen.opacity(0.8))
            .clipShape(Capsule())
            .foregroundColor(isSelected ? .black : .white)
            .shadow(radius: 2)
        }
    }
}
