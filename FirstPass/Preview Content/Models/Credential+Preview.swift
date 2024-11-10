import Foundation

extension Credential {
    static func mock() -> Credential {
        .init(
            name: "Google",
            url: URL(string: "https://google.com")!,
            username: "foo@google.com",
            password: "try-guessing-this!123"
        )
    }
}
