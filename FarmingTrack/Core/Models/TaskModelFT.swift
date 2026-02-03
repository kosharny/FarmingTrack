import Foundation

struct TaskStepFT: Identifiable, Codable, Hashable {
    var id: String { title } // reliable enough for this scope
    let title: String
    let description: String
    let durationSeconds: Int?
}

struct TaskModelFT: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let difficulty: String // Easy, Medium, Hard
    let category: String
    let imageName: String
    let steps: [TaskStepFT]
    let rewardPoints: Int
}
