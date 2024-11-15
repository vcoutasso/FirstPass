import Combine
import Foundation
import LocalAuthentication
import SwiftUI

@MainActor
final class FirstPassViewModel: ObservableObject {

    // MARK: Lifecycle

    init(credentials: Set<Credential> = .init(), authenticationContext: LAContext = .init()) {
        self.credentials = credentials
        self.authenticationContext = authenticationContext
    }

    // MARK: Internal

    @Published var searchQuery: String = ""
    @Published private(set) var isAuthenticated: Bool = false

     let authenticationContext: LAContext

    var filteredCredentials: [Credential] {
        if searchQuery.isEmpty {
            Array(credentials)
        } else {
            credentials.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    func updateCredential(_ credential: Credential) {
        if let index = credentials.firstIndex(where: { $0.id == credential.id }) {
            credentials.remove(at: index)
        }
        credentials.update(with: credential)
        objectWillChange.send()
    }

    func removeCredential(_ credential: Credential) {
        credentials.remove(credential)
        objectWillChange.send()
    }

    func authenticationHandler(_ result: (Result<Void, any Error>)) {
        if case .success = result {
            withAnimation {
                isAuthenticated = true
            }
        }
    }

    // MARK: Private

    private var credentials: Set<Credential>
}
