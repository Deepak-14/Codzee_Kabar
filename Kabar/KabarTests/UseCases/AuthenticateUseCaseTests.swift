//
//  AuthenticateUseCaseTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

struct AuthenticateUseCaseTests {
    @Test func testValidationRules() {
        let mockRepo = MockAuthRepository()
        let useCase = AuthenticateUseCase(repository: mockRepo)

        let emptyEmail = useCase.validate(email: "", password: "password123")
        #expect(emptyEmail.emailError == "Email is required")

        let invalidEmail = useCase.validate(email: "not-an-email", password: "password123")
        #expect(invalidEmail.emailError == "Please enter a valid email address")

        let emptyPassword = useCase.validate(email: "user@test.com", password: "")
        #expect(emptyPassword.passwordError == "Password is required")

        let shortPassword = useCase.validate(email: "user@test.com", password: "123")
        #expect(shortPassword.passwordError == "Password must contain at least 6 characters")

        let valid = useCase.validate(email: "user@test.com", password: "securePassword123")
        #expect(valid.emailError == nil)
        #expect(valid.passwordError == nil)
    }

    @Test func testExecuteRejectsInvalidInputBeforeCallingRepository() async {
        let mockRepo = MockAuthRepository()
        let useCase = AuthenticateUseCase(repository: mockRepo)

        // Empty email
        await #expect(throws: DomainError.validationError("Email is required")) {
            _ = try await useCase.execute(email: "", password: "password123")
        }

        // Invalid email format
        await #expect(throws: DomainError.validationError("Please enter a valid email address")) {
            _ = try await useCase.execute(email: "bad-email", password: "password123")
        }

        // Empty password
        await #expect(throws: DomainError.validationError("Password is required")) {
            _ = try await useCase.execute(email: "user@test.com", password: "")
        }

        // Short password
        await #expect(throws: DomainError.validationError("Password must contain at least 6 characters")) {
            _ = try await useCase.execute(email: "user@test.com", password: "123")
        }

        // Verify repository was never invoked
        #expect(mockRepo.isLoggedIn == false)
    }

    @Test func testAuthenticateSuccess() async throws {
        let mockRepo = MockAuthRepository()
        let useCase = AuthenticateUseCase(repository: mockRepo)

        let user = try await useCase.execute(email: "user@test.com", password: "password123")
        #expect(user.email == "test@kabar.com")
        #expect(mockRepo.isLoggedIn == true)
    }

    @Test func testAuthenticateRepositoryFailureThrowsError() async {
        let mockRepo = MockAuthRepository()
        let expectedError = DomainError.networkError("Authentication failed")
        mockRepo.shouldThrowError = expectedError

        let useCase = AuthenticateUseCase(repository: mockRepo)

        await #expect(throws: expectedError) {
            _ = try await useCase.execute(email: "user@test.com", password: "validPassword123")
        }
        #expect(mockRepo.isLoggedIn == false)
    }

    @Test func testLogoutSuccessAndGetCurrentUser() async throws {
        let mockRepo = MockAuthRepository()
        let logoutUseCase = LogoutUseCase(repository: mockRepo)
        let getCurrentUserUseCase = GetCurrentUserUseCase(repository: mockRepo)

        mockRepo.isLoggedIn = true
        #expect(getCurrentUserUseCase.execute() != nil)
        #expect(getCurrentUserUseCase.isUserLoggedIn() == true)

        try await logoutUseCase.execute()
        #expect(getCurrentUserUseCase.execute() == nil)
        #expect(getCurrentUserUseCase.isUserLoggedIn() == false)
    }

    @Test func testLogoutRepositoryFailureThrowsError() async {
        let mockRepo = MockAuthRepository()
        let expectedError = DomainError.unknown("Logout failed")
        mockRepo.isLoggedIn = true
        mockRepo.shouldThrowError = expectedError

        let logoutUseCase = LogoutUseCase(repository: mockRepo)
        let getCurrentUserUseCase = GetCurrentUserUseCase(repository: mockRepo)

        await #expect(throws: expectedError) {
            try await logoutUseCase.execute()
        }

        // Verify session survives when logout fails
        #expect(getCurrentUserUseCase.isUserLoggedIn() == true)
        #expect(getCurrentUserUseCase.execute() != nil)
    }
}
