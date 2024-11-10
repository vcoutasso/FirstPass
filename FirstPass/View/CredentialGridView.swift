import SwiftUI

// MARK: - CredentialGridView

struct CredentialGridView: View {

    // MARK: View state

    @Binding private(set) var credentials: Set<Credential>

    // MARK: Body

    var body: some View {
        Group {
            if credentials.isEmpty {
                emptyCredentialsView
            } else {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    ForEach(credentials.sorted(by: { $0.name < $1.name }), id: \.id) {
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
    @Previewable @State var credentials: Set<Credential> = Set([
        .init(name: "My Password", urlString: "someurl.com", username: "Username", password: "secret-password")
    ])

    CredentialGridView(credentials: $credentials)
}

#Preview("Empty Credentials") {
    @Previewable @State var credentials: Set<Credential> = .init()
    CredentialGridView(credentials: $credentials)
}
