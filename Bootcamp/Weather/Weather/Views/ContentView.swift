import SwiftUI

struct ContentView: View {
    @State private var city = ""
    @State private var isFetchingWeather = false
    @State private var weather: Weather?
    var body: some View {
        VStack {
            TextField("City", text: $city)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    isFetchingWeather = true
                }
                .task(id: isFetchingWeather) {
                    guard !city.isEmpty else { return }
                    await fethcWeather()
                    isFetchingWeather = false
                    city = ""
                }
            if let weather {
                Text(MeasurementFormatter.temperature(value: weather.main.temp))
                    .font(.system(size: 100))
                Text(weather.name)
            }
            Spacer()
        }
        .padding()
    }

    private func fethcWeather() async {
        do {
            guard let locations: [Location] = try await APIClient.shared.request(.getWeather(city: city)),
            let location = locations.first else { return }
            weather = try await APIClient.shared.request(.getCity(lat: location.lat, lon: location.lon))
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}

