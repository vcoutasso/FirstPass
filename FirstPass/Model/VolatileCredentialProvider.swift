import Combine
import Foundation

/// The default implementation for `CredentialProvider`
@MainActor
final class VolatileCredentialProvider: CredentialProvider {

    // MARK: Internal

    @Published var credentials: [Credential] = []

    func setCredential(_ credential: Credential) -> Result<Void, any Error> {
        #warning("properly implement `setCredential` business logic")
        credentials.append(credential)
        return .success(())
    }
}
