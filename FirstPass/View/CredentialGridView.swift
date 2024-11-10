import SwiftUI

// MARK: - CredentialGridView

struct CredentialGridView: View {

    // MARK: Internal

    @Binding var credentials: [Credential]
    private(set) var deleteCredentialCallback: (Credential) -> Void
    private(set) var updateCredentialCallback: (Credential) -> Void

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
                        ForEach(credentials.sorted(by: { $0.name < $1.name }), id: \.self) { credential in
                            CredentialCardView(credential: credential, onDelete: {
                                withAnimation(.spring(bounce: 0.3)) {
                                    deleteCredentialCallback(credential)
                                }
                            })
                            .onTapGesture {
                                isPresentingUpdateView = true
                            }
                            .sheet(isPresented: $isPresentingUpdateView) {
                                CredentialEditView(credential: credential, onSave: updateCredentialCallback)
                            }
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
    }

    // MARK: Private

    @State private var isPresentingUpdateView: Bool = false

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
        .init(name: "My Password", urlString: "someurl.com", username: "Username", password: "secret-password"),
        .init(name: "My Other Password", urlString: "somothereurl.com", username: "Username", password: "secret-password")
    ]

    CredentialGridView(credentials: $credentials, deleteCredentialCallback: { _ in credentials.removeFirst() }, updateCredentialCallback: { _ in })
        .frame(width: 640, height: 480)
}

#Preview("Empty Credentials") {
    @Previewable @State var credentials = [Credential]()
    
    CredentialGridView(credentials: $credentials, deleteCredentialCallback: { _ in }, updateCredentialCallback: { _ in })
}
