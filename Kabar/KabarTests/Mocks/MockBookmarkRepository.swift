//
//  MockBookmarkRepository.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Foundation
@testable import Kabar

final class MockBookmarkRepository: BookmarkRepositoryProtocol, @unchecked Sendable {
    var savedArticles: [Article] = []
    var shouldThrowError: Error?

    func getSavedArticles() async throws -> [Article] {
        if let error = shouldThrowError {
            throw error
        }
        return savedArticles
    }

    func saveArticle(_ article: Article) async throws {
        if let error = shouldThrowError {
            throw error
        }
        if !savedArticles.contains(where: { $0.id == article.id }) {
            savedArticles.append(article)
        }
    }

    func deleteArticle(id: UUID) async throws {
        if let error = shouldThrowError {
            throw error
        }
        savedArticles.removeAll { $0.id == id }
    }

    func isArticleSaved(id: UUID) async throws -> Bool {
        if let error = shouldThrowError {
            throw error
        }
        return savedArticles.contains { $0.id == id }
    }
}
