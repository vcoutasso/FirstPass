import Combine
import Foundation

@MainActor
final class FirstPassViewModel: ObservableObject {

    // MARK: Lifecycle

    init(credentials: Set<Credential> = .init()) {
        self.credentials = credentials
    }

    // MARK: Internal

    @Published var searchQuery: String = ""

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

    // MARK: Private

    private var credentials: Set<Credential>
}
