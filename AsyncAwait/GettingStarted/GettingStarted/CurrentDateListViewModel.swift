import Foundation

@MainActor
final class CurrentDateListViewModel: ObservableObject {
    @Published var currentDates: [CurrentDateViewModel] = []
    
    func populateDates() async throws {
        do {
            if let currentDate = try await WebService.shared.getDate() {
                let currentDateViewModel = CurrentDateViewModel(currentDate: currentDate)
                    self.currentDates.append(currentDateViewModel)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CurrentDateViewModel {
    let currentDate: CurrentDate
    
    var id: UUID {
        currentDate.id
    }
    var date: String {
        currentDate.date
    }
}
