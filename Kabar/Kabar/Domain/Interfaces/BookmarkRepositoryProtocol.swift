//
//  BookmarkRepositoryProtocol.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol BookmarkRepositoryProtocol: Sendable {
    func getSavedArticles() async throws -> [Article]
    func saveArticle(_ article: Article) async throws
    func deleteArticle(id: UUID) async throws
    func isArticleSaved(id: UUID) async throws -> Bool
}
