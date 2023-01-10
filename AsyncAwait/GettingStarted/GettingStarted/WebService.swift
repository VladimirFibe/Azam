import Foundation

final class WebService {
    
    static let shared = WebService()
    
    private init() {}
    func getDate() async throws -> CurrentDate? {
        guard let url = URL(string: "https://ember-sparkly-rule.glitch.me/current-date") else { fatalError("Url is incorrect!")}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDate.self, from: data)
    }
}
