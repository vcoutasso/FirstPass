import SwiftUI

// MARK: - CredentialGridView

struct CredentialGridView: View {

    @Binding var credentials: [Credential]
    private(set) var deleteCredentialCallback: (Credential) -> Void

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if credentials.isEmpty {
                    Spacer()

                    emptyCredentialsView

                    Spacer()
                } else {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                        ForEach(credentials.sorted(by: { $0.name < $1.name }), id: \.id) { credential in
                            CredentialCardView(credential: credential, onDelete: {
                                deleteCredentialCallback(credential)
                            })
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
    }

    // MARK: Properties

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
        .fixedSize()
        .frame(alignment: .center)
    }
}

// MARK: - SwiftUI Previews

#Preview("With Credentials") {
    @Previewable @State var credentials: [Credential] = [
        .init(name: "My Password", urlString: "someurl.com", username: "Username", password: "secret-password")
    ]

    CredentialGridView(credentials: $credentials, deleteCredentialCallback: { _ in })
}

#Preview("Empty Credentials") {
    @Previewable @State var credentials = [Credential]()
    
    CredentialGridView(credentials: $credentials, deleteCredentialCallback: { _ in })
}
