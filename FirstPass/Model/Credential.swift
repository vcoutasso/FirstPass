import Foundation

// MARK: - Credential

struct Credential: Identifiable {
    let id: UUID = .init()
    var name: String
    var urlString: String
    var username: String
    var password: String

    static func emptyCredential() -> Credential {
        .init(name: "", urlString: "", username: "", password: "")
    }

    func isValid() -> Bool {
        !name.isEmpty && !urlString.isEmpty && !username.isEmpty && !password.isEmpty
    }
}

// MARK: Hashable

extension Credential: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
