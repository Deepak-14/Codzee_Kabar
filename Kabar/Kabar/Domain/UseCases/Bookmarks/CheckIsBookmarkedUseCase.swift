//
//  CheckIsBookmarkedUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol CheckIsBookmarkedUseCaseProtocol: Sendable {
    func execute(id: UUID) async throws -> Bool
}

public final class CheckIsBookmarkedUseCase: CheckIsBookmarkedUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    public init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: UUID) async throws -> Bool {
        return try await repository.isArticleSaved(id: id)
    }
}
