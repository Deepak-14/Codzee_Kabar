//
//  BookmarkUseCasesTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

struct BookmarkUseCasesTests {
    @Test func testSaveAndGetBookmarks() async throws {
        let mockRepo = await MockBookmarkRepository()
        let saveUseCase = await SaveBookmarkUseCase(repository: mockRepo)
        let getUseCase = await GetBookmarksUseCase(repository: mockRepo)

        let article = await Article(id: UUID(), title: "Breaking Tech News")
        try await saveUseCase.execute(article: article)

        let saved = try await getUseCase.execute()
        #expect(saved.count == 1)
        #expect(saved.first?.id == article.id)
    }

    @Test func testDeleteBookmark() async throws {
        let mockRepo = await MockBookmarkRepository()
        let articleId = UUID()
        let article = await Article(id: articleId, title: "To be deleted")
        mockRepo.savedArticles = [article]

        let deleteUseCase = await DeleteBookmarkUseCase(repository: mockRepo)
        try await deleteUseCase.execute(id: articleId)

        #expect(mockRepo.savedArticles.isEmpty)
    }

    @Test func testCheckIsBookmarked() async throws {
        let mockRepo = await MockBookmarkRepository()
        let articleId = UUID()
        let article = await Article(id: articleId, title: "Bookmark test")
        mockRepo.savedArticles = [article]

        let checkUseCase = await CheckIsBookmarkedUseCase(repository: mockRepo)
        let isSaved = try await checkUseCase.execute(id: articleId)
        let isNotSaved = try await checkUseCase.execute(id: UUID())

        #expect(isSaved == true)
        #expect(isNotSaved == false)
    }

    @Test func testToggleBookmark() async throws {
        let mockRepo = await MockBookmarkRepository()
        let article = await Article(id: UUID(), title: "Toggle test")
        let toggleUseCase = await ToggleBookmarkUseCase(repository: mockRepo)

        // Initially not saved -> should save and return true
        let savedResult = try await toggleUseCase.execute(article: article)
        #expect(savedResult == true)
        #expect(mockRepo.savedArticles.count == 1)

        // Now saved -> should delete and return false
        let unsavedResult = try await toggleUseCase.execute(article: article)
        #expect(unsavedResult == false)
        #expect(mockRepo.savedArticles.isEmpty)
    }
}
