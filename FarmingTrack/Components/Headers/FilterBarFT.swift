import SwiftUI

struct FilterBarFT: View {
    @Binding var selectedCategory: String?
    let categories: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    withAnimation { selectedCategory = nil }
                }
                
                ForEach(categories, id: \.self) { category in
                    FilterChip(title: category, isSelected: selectedCategory == category) {
                        withAnimation {
                            if selectedCategory == category { selectedCategory = nil }
                            else { selectedCategory = category }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.FT.primaryYellow : Color.white.opacity(0.1))
                .foregroundColor(isSelected ? .black : .white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}
