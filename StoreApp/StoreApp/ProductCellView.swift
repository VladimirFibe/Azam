import SwiftUI

struct ProductCellView: View {
    let product: Product
    var body: some View {
        HStack(alignment: .top, spacing: 20.0) {
            if let url = product.images?[0] {
                AsyncImage(url: url) {
                    $0.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(
                        Text(product.price, format: .currency(code: Locale.currencyCode))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        , alignment: .bottom)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(product.title)
                    .bold()
                Text(product.description)
            }
            Spacer()
        }
    }
}

struct ProductCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellView(product: Product(
            id: 4,
            title: "Handmade Fresh Table",
            price: 687,
            description: "Andy shoes are designed to keeping in...",
            images: [URL(string: "https://placeimg.com/640/480/any?r=0.9178516507833767")!],
            category: Category(
                id: 5,
                name: "Other",
                image: "https://placeimg.com/640/480/any?r=0.9178516507833767")))
        .padding()
    }
}
