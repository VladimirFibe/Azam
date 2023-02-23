import SwiftUI

enum MessageType {
    case success
    case warning
    case error
}
struct MessageView: View {
    let title: String
    let message: String
    let messageType: MessageType
    
    private var backgroundColor: Color {
        switch messageType {
        case .success:
            return .green
        case .warning:
            return .yellow
        case .error:
            return .red
        }
    }
    var body: some View {
        VStack {
            Text(title).bold()
            Text(message)
        }
        .padding()
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(backgroundColor))
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(title: "Error", message: "Unable to load product", messageType: .error)
    }
}
