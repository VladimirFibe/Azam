import Foundation

struct Weather: Decodable {
    let main: Main
    let name: String

    struct Main: Decodable {
        let temp: Double
    }
}
