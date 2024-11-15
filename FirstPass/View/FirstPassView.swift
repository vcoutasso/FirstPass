import SwiftUI
import LocalAuthentication

// MARK: - FirstPassView

struct FirstPassView: View {

    // MARK: Lifecycle

    init(viewModel: FirstPassViewModel = .init()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Body

    var body: some View {
        Group {
            if appAuthentication && !viewModel.isAuthenticated {
                LocalAuthenticationView(reason: Text("Access your FirstPass credentials."), context: viewModel.authenticationContext, result: viewModel.authenticationHandler) {
                    Text("FirstPass is Locked")
                        .font(.headline)
                        .bold()
                }
            } else {
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
                    .onChange(of: scenePhase) { _, newPhase in
                        if newPhase == .active {
                            viewModel.activityDetected()
                        } else {
                            viewModel.inactivityDetected()
                        }
                    }
            }

        }
        .frame(minWidth: 640, minHeight: 480)
    }

    // MARK: Private 

    @AppStorage(AppStorageKey.appAuthenticationEnabled.rawValue) private var appAuthentication: Bool = true
    @Environment(\.scenePhase) private var scenePhase
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
