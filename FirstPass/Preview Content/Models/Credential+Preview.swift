import Foundation

extension Credential {
    static func mock() -> Credential {
        .init(
            name: "Google",
            urlString: "https://google.com",
            username: "foo@google.com",
            password: "try-guessing-this!123"
        )
    }
}
