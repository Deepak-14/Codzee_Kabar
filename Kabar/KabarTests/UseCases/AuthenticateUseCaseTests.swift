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

        let shortPassword = useCase.validate(email: "user@test.com", password: "123")
        #expect(shortPassword.passwordError == "Password must contain at least 6 characters")

        let valid = useCase.validate(email: "user@test.com", password: "securePassword123")
        #expect(valid.emailError == nil)
        #expect(valid.passwordError == nil)
    }

    @Test func testAuthenticateSuccess() async throws {
        let mockRepo = await MockAuthRepository()
        let useCase = await AuthenticateUseCase(repository: mockRepo)

        let user = try await useCase.execute(email: "user@test.com", password: "password123")
        #expect(user.email == "test@kabar.com")
        #expect(mockRepo.isLoggedIn == true)
    }

    @Test func testLogoutAndGetCurrentUser() async throws {
        let mockRepo = await MockAuthRepository()
        let logoutUseCase = await LogoutUseCase(repository: mockRepo)
        let getCurrentUserUseCase = await GetCurrentUserUseCase(repository: mockRepo)

        mockRepo.isLoggedIn = true
        #expect(getCurrentUserUseCase.execute() != nil)

        try await logoutUseCase.execute()
        #expect(getCurrentUserUseCase.execute() == nil)
        #expect(getCurrentUserUseCase.isUserLoggedIn() == false)
    }
}
