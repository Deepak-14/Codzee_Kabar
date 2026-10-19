//
//  GetBookmarksUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol GetBookmarksUseCaseProtocol: Sendable {
    func execute() async throws -> [Article]
}

public final class GetBookmarksUseCase: GetBookmarksUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    public init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Article] {
        return try await repository.getSavedArticles()
    }
}
