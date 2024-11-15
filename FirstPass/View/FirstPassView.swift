import SwiftUI
import LocalAuthentication

// MARK: - FirstPassView

/// A view that manages the main content of the FirstPass app, handling authentication and displaying the credential grid on success.
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
                CredentialGridView(viewModel: .init(repository: credentialsRepository))
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
    @EnvironmentObject private var credentialsRepository: CredentialsRepository
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: FirstPassViewModel
    @State private var isPresentingEditView: Bool = false
}

// MARK: - SwiftUI Previews

#Preview {
    FirstPassView(viewModel: .init())
        .frame(width: 800, height: 640)
}
