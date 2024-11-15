import Testing
@testable import FirstPass

// MARK: - CredentialTests

struct CredentialTests {

    @Test func credentialValidationShouldNotAllowEmptyStrings() async throws {
        #expect(makeCredential(name: "").isValid() == false)
        #expect(makeCredential(url: "").isValid() == false)
        #expect(makeCredential(username: "").isValid() == false)
        #expect(makeCredential(password: "").isValid() == false)
        #expect(makeCredential().isValid() == true)
    }

}

// MARK: Helpers

private extension CredentialTests {
    private func makeCredential(
        name: String = "name",
        url: String = "url",
        username: String = "username",
        password: String = "password"
    ) -> Credential {
        Credential(name: name, urlString: url, username: username, password: password)
    }
}
