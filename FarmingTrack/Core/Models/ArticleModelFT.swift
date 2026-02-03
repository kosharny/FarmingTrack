import Foundation

struct ArticleModelFT: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let description: String?
    let content: String
    let imageName: String
    let category: String
    let readTimeMinutes: Int
}
