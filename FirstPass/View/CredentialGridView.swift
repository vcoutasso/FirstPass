import SwiftUI

// MARK: - CredentialGridView

struct CredentialGridView: View {

    // MARK: View state

    @State var credentials: [Credential]

    // MARK: Body

    var body: some View {
        Group {
            if credentials.isEmpty {
                emptyCredentialsView
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(credentials, id: \.id) {
                        CredentialCardView(credential: $0)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: Private properties

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
}

// MARK: - Helper Views

private extension CredentialGridView {
    private var emptyCredentialsView: some View {
        VStack {
            Image(systemName: "key.card")
                .font(.system(.largeTitle))

            Text("No Credentials")
                .bold()
        }
        .frame(alignment: .center)
    }
}

// MARK: - SwiftUI Previews

#Preview("With Credentials") {
    CredentialGridView(credentials: [.init(name: "My Password", url: .init(string: "someurl.com")!, username: "Username", password: "secret-password")])
}

#Preview("Empty Credentials") {
    CredentialGridView(credentials: [])
}
