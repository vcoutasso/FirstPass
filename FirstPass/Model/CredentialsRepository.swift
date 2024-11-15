import Combine

// MARK: - CredentialsStoring

@MainActor
protocol CredentialsStoring: ObservableObject {

    var credentials: Set<Credential> { get }
    var credentialsPublished: Published<Set<Credential>> { get }
    var credentialsPublisher: Published<Set<Credential>>.Publisher { get }

    func updateCredential(_: Credential)
    func removeCredential(_: Credential)
}

// MARK: - CredentialsRepository

/// A repository for managing a collection of credentials, supporting real-time updates for SwiftUI views.
@MainActor
final class CredentialsRepository: CredentialsStoring {

    // MARK: Lifecycle

    init(credentials: Set<Credential> = []) {
        self.credentials = credentials
    }

    // MARK: Internal

    @Published private(set) var credentials: Set<Credential>
    var credentialsPublished: Published<Set<Credential>> { _credentials }
    var credentialsPublisher: Published<Set<Credential>>.Publisher { $credentials }

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
}
