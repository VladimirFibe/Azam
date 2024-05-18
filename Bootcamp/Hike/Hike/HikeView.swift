import SwiftUI

struct HikeView: View {
    let hikes = Hike.hikes
    var body: some View {
        NavigationStack {
            List(hikes) { hike in
                NavigationLink(value: hike) {
                    HikeCell(hike: hike)
                }
            }
            .navigationTitle("Hikes")
            .navigationDestination(for: Hike.self) { hike in
                HikeDetailView(hike: hike)
            }
        }
    }
}

struct HikeCell: View {
    let hike: Hike
    var body: some View {
        HStack(alignment: .top) {
            Image(hike.photo)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 100)
            VStack(alignment: .leading) {
                Text(hike.name)
                Text(hike.miles.formatted()) + Text(" miles")
            }
        }
    }
}

#Preview {
    HikeView()
}
