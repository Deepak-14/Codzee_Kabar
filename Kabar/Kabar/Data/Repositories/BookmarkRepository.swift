//
//  BookmarkRepository.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public final class BookmarkRepository: BookmarkRepositoryProtocol {
    private let localDataSource: BookmarkLocalDataSourceProtocol

    public init(localDataSource: BookmarkLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    @MainActor
    public func getSavedArticles() async throws -> [Article] {
        let entities = try localDataSource.fetchAll()
        return entities.map { $0.toDomain() }
    }

    @MainActor
    public func saveArticle(_ article: Article) async throws {
        let entity = NewsArticleSave(from: article)
        try localDataSource.save(entity)
    }

    @MainActor
    public func deleteArticle(id: UUID) async throws {
        try localDataSource.delete(id: id)
    }

    @MainActor
    public func isArticleSaved(id: UUID) async throws -> Bool {
        let existing = try localDataSource.fetch(by: id)
        return existing != nil
    }
}
