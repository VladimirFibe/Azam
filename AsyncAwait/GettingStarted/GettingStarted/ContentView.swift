import SwiftUI

struct CurrentDate: Decodable, Identifiable {
    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}

struct ContentView: View {
    @State private var currentDates: [CurrentDate] = []
    
    private func populateDates() async  {
        do {
            guard let currentDate = try await getDate() else {
                return
            }
            
            self.currentDates.append(currentDate)
        } catch {
            print(error.localizedDescription)
        }
    }
    var body: some View {
        NavigationView {
            List(currentDates) { currentDate in
                Text("\(currentDate.date)")
            }
            .listStyle(.plain)
            .navigationTitle("Dates")
            .toolbar {
                button
            }
            .task {
                await populateDates()
            }
        }
    }
    var button: some View {
        Button {
            Task {
                await populateDates()
            }
        } label: {
            Image(systemName: "arrow.clockwise.circle")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
