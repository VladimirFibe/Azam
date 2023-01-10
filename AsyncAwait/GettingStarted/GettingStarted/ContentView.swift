import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrentDateListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.currentDates) { currentDate in
                Text("\(currentDate.date)")
            }
            .listStyle(.plain)
            .navigationTitle("Dates")
            .toolbar {
                button
            }
            .task {
                await viewModel.populateDates()
            }
        }
    }
    var button: some View {
        Button {
            Task {
                await viewModel.populateDates()
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
