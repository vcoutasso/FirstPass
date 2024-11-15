import Testing
@testable import FirstPass

@MainActor
struct CredentialsRepositoryTests {

    @Test func updateCredentialShouldAddNewEntry() {
        let newCredential = Credential.mock()
        let sut = CredentialsRepository()

        #expect(sut.credentials.isEmpty)

        sut.updateCredential(newCredential)

        #expect(sut.credentials.contains(newCredential))
    }

    @Test func updateCredentialShouldReplaceCredential() {
            var newCredential = Credential.mock()
            let newPassword = "bolodemorango"
            let sut = CredentialsRepository()

            // Add
            sut.updateCredential(newCredential)

            // As the ID remains the same, t
            newCredential.password = newPassword

            // Update
            sut.updateCredential(newCredential)

            #expect(sut.credentials.first?.password == newPassword)
    }

    @Test func removeCredentialShouldRemoveWhenProvidedWithExistingEntry() {
        let sut = CredentialsRepository()
        let credential = Credential.mock()

        sut.updateCredential(credential)
        sut.removeCredential(credential)

        #expect(sut.credentials.isEmpty == true)
    }

    @Test func removeCredentialShouldNotRemoveWhenProvidedWithNonExistingEntry() {
        let sut = CredentialsRepository()
        let credential1 = Credential.mock()
        // Same data but UUID is different
        let credential2 = Credential.mock()

        sut.updateCredential(credential1)
        sut.removeCredential(credential2)

        #expect(sut.credentials.count == 1)
    }
}
