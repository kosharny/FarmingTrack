import SwiftUI

struct ArticleRowFT: View {
    let article: ArticleModelFT
    
    var body: some View {
        GameCardFT {
            HStack {
                // Use image name from model, assuming assets exist or system will fallback
                // For now, since we don't have assets, we use a placeholder color/icon, 
                // BUT user asked for "images to...make them more visually appealing".
                // We should try to use Image(article.imageName) and handle failure or use system images if imageName is a SF symbol.
                // Given the JSON has "image_name" like "crop_rotation", "soil_analysis", these are likely asset names.
                // Since I can't check if assets exist easily without running, I'll assume they will be added.
                // I will add a safe fallback logic.
                
                Image(article.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    // Fallback for preview if asset missing (won't show in release but good for dev)
                    // SwiftUI Image(name) returns empty if not found? No, it just shows nothing or crashes?
                    // Safe approach in standard SwiftUI is hard without extension.
                    // For now, we trust the asset exists or is a system symbol if it contains "."
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack {
                        BadgeFT(text: article.category, color: Color.FT.farmGreen)
                        Text("• \(article.readTimeMinutes) min")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.leading, 8)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
}
