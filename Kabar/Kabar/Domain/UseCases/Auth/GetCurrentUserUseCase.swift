//
//  GetCurrentUserUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol GetCurrentUserUseCaseProtocol: Sendable {
    func execute() -> User?
    func isUserLoggedIn() -> Bool
}

public final class GetCurrentUserUseCase: GetCurrentUserUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> User? {
        return repository.getCurrentUser()
    }

    public func isUserLoggedIn() -> Bool {
        return repository.isUserLoggedIn()
    }
}
