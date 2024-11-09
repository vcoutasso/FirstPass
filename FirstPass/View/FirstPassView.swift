import SwiftUI

// MARK: - FirstPassView

struct FirstPassView: View {

    // MARK: View state

    @State var credentials: [Credential]

    var body: some View {
        CredentialGridView(credentials: credentials)
    }
}

// MARK: - SwiftUI Previews

#Preview {
    FirstPassView(credentials: .init(repeating: .mock(), count: 10))
        .frame(width: 800, height: 640)
}
