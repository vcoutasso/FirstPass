import SwiftUI

// MARK: - FirstPassApp

@main
struct FirstPassApp: App {

    // MARK: Body

    var body: some Scene {
        WindowGroup {
            FirstPassView()
        }
        .defaultSize(width: 640, height: 480)
    }
}
