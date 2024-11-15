import Combine

// MARK: - CredentialGridViewModel

/// View model that manages a list of credentials and exposes functionality to filter it
@MainActor
final class CredentialGridViewModel: ObservableObject {

    // MARK: Lifecycle

    init(repository: CredentialsRepository) {
        self.repository = repository

        repository.$credentials
            .combineLatest($searchQuery)
            .map { credentials, query in
                (Array(credentials), query)
            }
            .sink { [weak self] credentials, query in
                guard let self else { return }
                filteredCredentials = query.isEmpty ? credentials
                    : credentials.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
            }
            .store(in: &cancellables)
    }

    // MARK: Internal

    @Published private(set) var filteredCredentials: [Credential] = []
    @Published var searchQuery: String = ""

    func updateCredential(_ credential: Credential) {
        repository.updateCredential(credential)
    }

    func removeCredential(_ credential: Credential) {
        repository.removeCredential(credential)
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []
    private let repository: CredentialsRepository
}
