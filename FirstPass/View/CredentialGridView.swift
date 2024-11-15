import SwiftUI

// MARK: - CredentialGridView

/// A view that displays a grid of credentials, allowing users to view, add, update, and delete credentials.
struct CredentialGridView: View {

    // MARK: Lifecycle

    init(viewModel: CredentialGridViewModel) {
        self.viewModel = viewModel
    }

    init(repository: CredentialsRepository) {
        self.init(viewModel: .init(repository: repository))
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if viewModel.filteredCredentials.isEmpty {
                    Spacer()

                    emptyCredentialsView

                    Spacer()
                } else {
                    GeometryReader { geometry in
                        LazyVGrid(columns: gridColumns(width: geometry.size.width), alignment: .leading) {
                            ForEach(viewModel.filteredCredentials.sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }), id: \.self) { credential in
                                CredentialCardView(credential: credential, onDelete: {
                                    withAnimation(.spring(bounce: 0.3)) {
                                        viewModel.removeCredential(credential)
                                    }
                                })
                                .onTapGesture {
                                    isPresentingUpdateView = true
                                }
                                .sheet(isPresented: $isPresentingUpdateView) {
                                    CredentialEditView(credential: credential, onSave: viewModel.updateCredential)
                                }
                            }
                        }
                    }
                }
            }
            .padding()

            Spacer()
        }
        .searchable(text: $viewModel.searchQuery, prompt: Text("Credential name"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isPresentingNewCredentialView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingNewCredentialView) {
            CredentialEditView(credential: .emptyCredential()) { credential in
                viewModel.updateCredential(credential)
            }
        }
    }

    // MARK: Private

    @ObservedObject private var viewModel: CredentialGridViewModel

    @State private var isPresentingUpdateView: Bool = false
    @State private var isPresentingNewCredentialView: Bool = false

    private func gridColumns(width: CGFloat) -> [GridItem] {
        let columns = max(3, Int(width) / Int(CredentialCardView.maxWidth))

        return .init(repeating: .init(.flexible(minimum: CredentialCardView.minWidth, maximum: CredentialCardView.maxWidth)), count: columns)
    }
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
    let credentials: [Credential] = [
        .init(name: "My Password", urlString: "someurl.com", username: "Username", password: "secret-password"),
        .init(name: "My Other Password", urlString: "somothereurl.com", username: "Username", password: "secret-password")
    ]

    let repository = CredentialsRepository(credentials: Set(credentials))

    CredentialGridView(repository: repository)
        .frame(width: 640, height: 480)
}

#Preview("Empty Credentials") {
    let repository = CredentialsRepository(credentials: [])

    CredentialGridView(repository: repository)
}
