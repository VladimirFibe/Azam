import SwiftUI

struct ContentView: View {
    let urlString = "https://images.unsplash.com/photo-1552727131-5fc6af16796d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3898&q=80"
    var body: some View {
        VStack {
            Image(.costarica)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 16))

            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } placeholder: {
                ProgressView()
            }

            Text("Hello, SwiftUI!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
