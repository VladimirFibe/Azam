import SwiftUI
import Observation

@Observable
class AppState {
    var isOn = false
    var backgrounColor: Color {
        isOn ? .black.opacity(0.3) : .cyan.opacity(0.3)
    }
    var systemName: String {
        isOn ? "lightbulb.fill" : "lightbulb"
    }
    var foregroundColor: Color {
        isOn ? .yellow : .gray
    }
}
struct LightBulbView: View {
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        @Bindable var appState = appState
        VStack(spacing: 50) {
            Image(systemName: appState.systemName)
                .font(.largeTitle)
                .foregroundStyle(appState.foregroundColor)
            Toggle("ON", isOn: $appState.isOn)
            .fixedSize()
        }
    }
}

struct ContentView: View {
    @Environment(AppState.self) var appState: AppState
    var body: some View {
        VStack {
            LightBulbView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appState.backgrounColor)
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
