import SwiftUI

// MARK: - FirstPassView

struct FirstPassView: View {

    // MARK: Lifecycle

    init(viewModel: FirstPassViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Body

    var body: some View {
        CredentialGridView(credentials: .constant(viewModel.filteredCredentials), deleteCredentialCallback: viewModel.removeCredential, updateCredentialCallback: viewModel.updateCredential)
            .searchable(text: $viewModel.searchQuery, prompt: Text("Credential name"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingEditView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingEditView) {
                CredentialEditView(credential: .emptyCredential()) { credential in
                    viewModel.updateCredential(credential)
                }
            }
    }

    // MARK: Private 

    @StateObject private var viewModel: FirstPassViewModel
    @State private var isPresentingEditView: Bool = false
}

// MARK: - SwiftUI Previews

#Preview {
    let credentials: [Credential] = {
        var array = [Credential]()
        for _ in 1...10 { array.append(.mock()) }
        return array
    }()
    let vm = FirstPassViewModel(credentials: Set(credentials))

    FirstPassView(viewModel: vm)
        .frame(width: 800, height: 640)
}
