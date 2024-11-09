import SwiftUI

@main
struct FirstPassApp: App {
    var body: some Scene {
        WindowGroup {
            FirstPassView(credentials: [])
        }
    }
}
