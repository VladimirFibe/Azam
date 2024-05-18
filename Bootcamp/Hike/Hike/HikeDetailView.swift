import SwiftUI

struct HikeDetailView: View {
    @State private var zoom = false
    let hike: Hike
    var body: some View {
        VStack {
            Image(hike.photo)
                .resizable()
                .aspectRatio(contentMode: zoom ? .fill : .fit )
                .onTapGesture {
                    withAnimation {
                        self.zoom.toggle()
                    }
                }
            Text(hike.name)
            Text("\(hike.miles.formatted()) miles")
            Spacer()
        }
        .navigationTitle(hike.name)
    }
}

#Preview {
    NavigationStack {
        HikeDetailView(hike: Hike.hikes[0])
    }
}
