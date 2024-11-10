import Foundation

// MARK: - Credential

struct Credential: Identifiable {
    let id: UUID = .init()
    let name: String
    let url: URL
    let username: String
    let password: String
}

// MARK: Hashable

extension Credential: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
