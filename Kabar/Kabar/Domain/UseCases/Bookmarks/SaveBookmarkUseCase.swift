//
//  SaveBookmarkUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol SaveBookmarkUseCaseProtocol: Sendable {
    func execute(article: Article) async throws
}

public final class SaveBookmarkUseCase: SaveBookmarkUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    public init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(article: Article) async throws {
        try await repository.saveArticle(article)
    }
}
