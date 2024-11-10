import Combine
import Foundation

/// Protocol for types that provide credentials throughout the entire app.
@MainActor
protocol CredentialProvider: ObservableObject {
    var credentials: [Credential] { get }

    /// Creates or updates the value of a credential. If the underlying `set` operation fails, no changes should be broadcasted.
    func setCredential(_ credential: Credential) -> Result<Void, any Error>
}
