//
//  LoginViewModel.swift
//  Kabar
//
//  Created by user on 26/08/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
public final class LoginViewModel {
    private let authenticateUseCase: AuthenticateUseCaseProtocol

    public var email: String = ""
    public var password: String = ""
    public var emailError: String?
    public var passwordError: String?
    public var isLoading: Bool = false

    public init(authenticateUseCase: AuthenticateUseCaseProtocol) {
        self.authenticateUseCase = authenticateUseCase
    }

    public convenience init() {
        self.init(authenticateUseCase: AppDIContainer.shared.authenticateUseCase)
    }

    public func validate() -> Bool {
        let result = authenticateUseCase.validate(email: email, password: password)
        emailError = result.emailError
        passwordError = result.passwordError
        return result.emailError == nil && result.passwordError == nil
    }

    public func login() async -> Bool {
        guard validate() else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            _ = try await authenticateUseCase.execute(email: email, password: password)
            return true
        } catch {
            emailError = error.localizedDescription
            return false
        }
    }

    // Convenience method matching previous signature for view compatibility
    public func createUser(email: String, password: String, completion: @escaping @MainActor (Bool) -> Void) {
        Task {
            let success = await login()
            completion(success)
        }
    }
}
