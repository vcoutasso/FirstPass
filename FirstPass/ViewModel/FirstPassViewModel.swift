import Combine
import Foundation
import LocalAuthentication
import SwiftUI

/// View model that manages the app's authentication state, including biometric authentication
/// and activity/inactivity monitoring for automatic session management.
@MainActor
final class FirstPassViewModel: ObservableObject {

    // MARK: Lifecycle

    init(authenticationContext: LAContext = .init(), inactivityTimeout: TimeInterval = 1 * 60) {
        self.authenticationContext = authenticationContext
        self.inactivityTimeout = inactivityTimeout
    }

    // MARK: Internal

    @Published private(set) var isAuthenticated: Bool = false

    private(set) var authenticationContext: LAContext

    func authenticationHandler(_ result: (Result<Void, any Error>)) {
        if case .success = result {
            withAnimation {
                isAuthenticated = true
            }
        }
    }

    func activityDetected() {
        cancellable?.cancel()
        cancellable = nil
    }

    func inactivityDetected() {
        cancellable?.cancel()
        cancellable = Just(())
            .delay(for: .init(inactivityTimeout), scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                withAnimation {
                    // Reset context so the user can re-authenticate
                    self?.authenticationContext = LAContext()
                    self?.isAuthenticated = false
                }
            }
    }

    // MARK: Private

    private var cancellable: AnyCancellable?
    private let inactivityTimeout: TimeInterval
}
