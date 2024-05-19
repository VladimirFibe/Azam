import SwiftUI

struct FriendsView: View {
    @State private var search = ""
    @State private var name = ""
    @State private var friends: [Friend] = [.init(name: "John"), .init(name: "Mary"), .init(name: "Steven"), .init(name: "Steve"), .init(name: "Jerry")]
    @State private var filtered: [Friend] = []
    var body: some View {
        VStack {
            List(filtered) { friend in
                Text(friend.name)
            }
            .listStyle(.plain)
            .searchable(text: $search)
            .onChange(of: search) { oldValue, newValue in
                filtered = search.isEmpty ? friends : friends.filter { $0.name.contains(search)}
            }
            TextField("Enter name", text: $name)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    friends.append(Friend(name: name))
                    name = ""
                }

        }
        .padding()
        .navigationTitle("Friends")
        .onAppear {
            filtered = friends
        }
    }
}

#Preview {
    NavigationStack {
        FriendsView()
    }
}

struct Friend: Identifiable {
    let id = UUID()
    let name: String
}
