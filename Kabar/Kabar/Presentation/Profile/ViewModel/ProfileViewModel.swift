//
//  ProfileViewModel.swift
//  Kabar
//
//  Created by user on 26/08/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
public final class ProfileViewModel {
    private let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol

    public var email: String = ""
    public var errorMessage: String?

    public init(
        getCurrentUserUseCase: GetCurrentUserUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol
    ) {
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.logoutUseCase = logoutUseCase
    }

    public convenience init() {
        self.init(
            getCurrentUserUseCase: AppDIContainer.shared.getCurrentUserUseCase,
            logoutUseCase: AppDIContainer.shared.logoutUseCase
        )
    }

    public func fetchUser() {
        if let user = getCurrentUserUseCase.execute() {
            self.email = user.email ?? ""
        }
    }

    public func userLogout() async -> Bool {
        do {
            try await logoutUseCase.execute()
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error signing out: \(error)")
            return false
        }
    }
}
