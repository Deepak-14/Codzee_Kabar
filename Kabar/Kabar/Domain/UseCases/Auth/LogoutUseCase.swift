//
//  LogoutUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol LogoutUseCaseProtocol: Sendable {
    func execute() async throws
}

public final class LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.logout()
    }
}
