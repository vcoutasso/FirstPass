import Foundation

struct Credential: Identifiable {
    let id: UUID = .init()
    let name: String
    let url: URL
    let username: String
    let password: String
}
