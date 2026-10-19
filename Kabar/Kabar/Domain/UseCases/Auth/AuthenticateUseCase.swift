//
//  AuthenticateUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol AuthenticateUseCaseProtocol: Sendable {
    func execute(email: String, password: String) async throws -> User
    func validate(email: String, password: String) -> (emailError: String?, passwordError: String?)
}

public final class AuthenticateUseCase: AuthenticateUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func validate(email: String, password: String) -> (emailError: String?, passwordError: String?) {
        var emailError: String?
        var passwordError: String?

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            emailError = "Email is required"
        } else if !trimmedEmail.isValidEmail() {
            emailError = "Please enter a valid email address"
        }

        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must contain at least 6 characters"
        }

        return (emailError, passwordError)
    }

    public func execute(email: String, password: String) async throws -> User {
        let validation = validate(email: email, password: password)
        if let emailError = validation.emailError {
            throw DomainError.validationError(emailError)
        }
        if let passwordError = validation.passwordError {
            throw DomainError.validationError(passwordError)
        }

        return try await repository.authenticate(
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        )
    }
}
