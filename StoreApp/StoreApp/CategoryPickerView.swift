import SwiftUI

struct CategoryPickerView: View {
    let client = StoreHTTPClient()
    @State private var categories: [Category] = []
    @State private var selectedCategory: Category?
    let onSelected: (Category) -> Void
    var body: some View {
        Picker("Categories", selection: $selectedCategory) {
            ForEach(categories) { category in
                Text(category.name)
                    .tag(Optional(category))
            }
        }
        .pickerStyle(.wheel)
        .onChange(of: selectedCategory, perform: { category in
            if let category {
                onSelected(category)
            }
        })
            .task {
                do {
                    categories = try await client.getAllCategories()
                    selectedCategory = categories.first
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerView(onSelected: { _ in })
    }
}
