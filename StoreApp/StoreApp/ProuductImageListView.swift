import SwiftUI

struct ProuductImageListView: View {
    let images: [UIImage]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }
}

struct ProuductImageListView_Previews: PreviewProvider {
    static var previews: some View {
        ProuductImageListView(images: [])
    }
}
