//
//  ToggleBookmarkUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol ToggleBookmarkUseCaseProtocol: Sendable {
    @discardableResult
    func execute(article: Article) async throws -> Bool
}

public final class ToggleBookmarkUseCase: ToggleBookmarkUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    public init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    @discardableResult
    public func execute(article: Article) async throws -> Bool {
        let isSaved = try await repository.isArticleSaved(id: article.id)
        if isSaved {
            try await repository.deleteArticle(id: article.id)
            return false
        } else {
            try await repository.saveArticle(article)
            return true
        }
    }
}
