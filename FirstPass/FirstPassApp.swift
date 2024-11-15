import SwiftUI

// MARK: - FirstPassApp

/// App entry point
@main
struct FirstPassApp: App {

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            FirstPassView()
        }
        .environmentObject(credentialsRepository)
        .windowResizability(.contentSize)
        .defaultSize(width: 640, height: 480)

        Settings {
            SettingsView()
        }
    }

    // MARK: Private

    private let credentialsRepository = CredentialsRepository()
}
