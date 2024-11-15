import Combine
import Testing
@testable import FirstPass

// MARK: - CredentialGridViewModelTests

@MainActor
struct CredentialGridViewModelTests {

    @Test func updateCredentialShouldReflectChangesOnRepository() {
        let spy = CredentialsRepositorySpy()
        let sut = CredentialGridViewModel(repository: spy)

        sut.updateCredential(.mock())
        #expect(spy.didUpdateCredential == true)
    }

    @Test func removeCredentialShouldReflectChangesOnRepository() {
        let spy = CredentialsRepositorySpy()
        let sut = CredentialGridViewModel(repository: spy)

        sut.removeCredential(.mock())
        #expect(spy.didRemoveCredential == true)
    }
}

// MARK: CredentialsRepositorySpy

final class CredentialsRepositorySpy: CredentialsStoring {
    @Published var credentials: Set<FirstPass.Credential> = []

    var credentialsPublished: Published<Set<FirstPass.Credential>> { _credentials }

    var credentialsPublisher: Published<Set<FirstPass.Credential>>.Publisher { $credentials }

    private(set) var didUpdateCredential: Bool = false
    func updateCredential(_: Credential) {
        didUpdateCredential = true
    }

    private(set) var didRemoveCredential: Bool = false
    func removeCredential(_: Credential) {
        didRemoveCredential = true
    }
}
