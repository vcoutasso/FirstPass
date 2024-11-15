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

    private(set) var authenticationContext: LAContext

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

    func activityDetected() {
        cancellable?.cancel()
        cancellable = nil
    }

    func inactivityDetected() {
        cancellable?.cancel()
        cancellable = Just(())
            .delay(for: .init(Self.authenticationDuration), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                withAnimation {
                    // Reset context so the user can re-authenticate
                    self?.authenticationContext = LAContext()
                    self?.isAuthenticated = false
                }
            }
    }

    // MARK: Private

    private var cancellable: AnyCancellable?
    private var credentials: Set<Credential>

    private static let authenticationDuration: TimeInterval = 1 * 60
}
