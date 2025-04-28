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

        MenuBarExtra("FirstPass", systemImage: "key.2.on.ring") {
            MenuBarView()
                .environmentObject(credentialsRepository)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
    }

    // MARK: Private

    @StateObject private var credentialsRepository = CredentialsRepository()
}
