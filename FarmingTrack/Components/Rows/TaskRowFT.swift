import SwiftUI

struct TaskRowFT: View {
    let task: TaskModelFT
    
    var body: some View {
        GameCardFT {
            HStack {
                Image(task.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack {
                        BadgeFT(text: task.difficulty, color: Color.FT.accentRed)
                        Text("• \(task.steps.count) Steps")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.leading, 8)
                
                Spacer()
                
                if false { // Logic for completed state handled by parent usually, but row can show "Done"
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.FT.farmGreen)
                } else {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.FT.primaryYellow)
                }
            }
        }
    }
}
