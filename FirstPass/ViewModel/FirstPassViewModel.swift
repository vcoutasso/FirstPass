import Combine
import Foundation

@MainActor
final class FirstPassViewModel: ObservableObject {

    // MARK: Lifecycle

    init(credentials: Set<Credential> = .init()) {
        self.credentials = credentials
    }

    // MARK: Internal

    @Published var credentials: Set<Credential>

    func updateCredential(_ credential: Credential) {
        credentials.update(with: credential)
    }
}
