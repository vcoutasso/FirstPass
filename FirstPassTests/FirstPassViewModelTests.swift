import Foundation
import Testing
@testable import FirstPass

@MainActor
struct FirstPassViewModelTests {

    @Test func authenticationHandlerShouldAuthenticateOnSuccess() {
        let sut = FirstPassViewModel()
        #expect(sut.isAuthenticated == false)
        sut.authenticationHandler(.success(()))
        #expect(sut.isAuthenticated == true)
    }

    @Test func authenticationHandlerShouldNotAuthenticateOnFailure() {
        let sut = FirstPassViewModel()
        #expect(sut.isAuthenticated == false)
        sut.authenticationHandler(.failure(NSError(domain: "", code: 0)))
        #expect(sut.isAuthenticated == false)
    }

    @Test func inactivityTimeoutShouldResetAuthentication() async throws {
        let sut = FirstPassViewModel(inactivityTimeout: 0.2)
        // Given that authentication succeeded
        sut.authenticationHandler(.success(()))
        #expect(sut.isAuthenticated == true)

        // Trigger countdown
        sut.inactivityDetected()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(sut.isAuthenticated == false)
    }

    @Test func inactivityTimeoutShouldCreateNewAuthenticationContext() async throws {
        let sut = FirstPassViewModel(inactivityTimeout: 0.2)
        let originalContext = sut.authenticationContext

        // Given that authentication succeeded
        sut.authenticationHandler(.success(()))
        #expect(sut.isAuthenticated == true)

        // Trigger countdown
        sut.inactivityDetected()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(sut.authenticationContext != originalContext)
    }

    @Test func activityDetectionShouldStopInactivityCountdown() async throws {
        let sut = FirstPassViewModel(inactivityTimeout: 0.2)
        // Given that authentication succeeded
        sut.authenticationHandler(.success(()))
        #expect(sut.isAuthenticated == true)

        // Trigger countdown
        sut.inactivityDetected()
        // User is back to the app before timeout expires
        sut.activityDetected()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(sut.isAuthenticated == true)
    }
}
