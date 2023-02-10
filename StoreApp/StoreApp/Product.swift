import Foundation

struct Product: Codable {
    let id: Int?
    let title: String
    let price: Double
    let description: String
    let images: [URL]?
    let category: Category
}
