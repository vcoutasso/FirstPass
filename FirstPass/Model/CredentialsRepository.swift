import Combine

// MARK: - CredentialsRepository

@MainActor
final class CredentialsRepository: ObservableObject {

    // MARK: Lifecycle

    init(credentials: Set<Credential> = []) {
        self.credentials = credentials
    }

    // MARK: Internal

    @Published private(set) var credentials: Set<Credential>

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
