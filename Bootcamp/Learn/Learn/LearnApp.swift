import SwiftUI

@main
struct LearnApp: App {
    @State private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
