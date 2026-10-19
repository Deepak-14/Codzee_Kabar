//
//  BookmarkViewModelTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

@MainActor
struct BookmarkViewModelTests {
    @Test func testFetchAllBookmarks() async {
        let mockRepo = MockBookmarkRepository()
        let article = Article(id: UUID(), title: "Saved Story")
        mockRepo.savedArticles = [article]

        let getUseCase = GetBookmarksUseCase(repository: mockRepo)
        let deleteUseCase = DeleteBookmarkUseCase(repository: mockRepo)
        let viewModel = BookmarkViewModel(getBookmarksUseCase: getUseCase, deleteBookmarkUseCase: deleteUseCase)

        await viewModel.fetchAllBookmarks()

        #expect(viewModel.savedNews.count == 1)
        #expect(viewModel.filteredNews.count == 1)
    }

    @Test func testDeleteBookmarkUpdatesState() async {
        let mockRepo = MockBookmarkRepository()
        let articleId = UUID()
        let article = Article(id: articleId, title: "Delete Me")
        mockRepo.savedArticles = [article]

        let getUseCase = GetBookmarksUseCase(repository: mockRepo)
        let deleteUseCase = DeleteBookmarkUseCase(repository: mockRepo)
        let viewModel = BookmarkViewModel(getBookmarksUseCase: getUseCase, deleteBookmarkUseCase: deleteUseCase)

        await viewModel.fetchAllBookmarks()
        #expect(viewModel.savedNews.count == 1)

        await viewModel.deleteBookmark(id: articleId)
        #expect(viewModel.savedNews.isEmpty)
        #expect(mockRepo.savedArticles.isEmpty)
    }

    @Test func testSearchFilterOnBookmarks() async {
        let mockRepo = MockBookmarkRepository()
        let article1 = Article(id: UUID(), title: "iOS Clean Architecture")
        let article2 = Article(id: UUID(), title: "SwiftUI Animation")
        mockRepo.savedArticles = [article1, article2]

        let getUseCase = GetBookmarksUseCase(repository: mockRepo)
        let deleteUseCase = DeleteBookmarkUseCase(repository: mockRepo)
        let viewModel = BookmarkViewModel(getBookmarksUseCase: getUseCase, deleteBookmarkUseCase: deleteUseCase)

        await viewModel.fetchAllBookmarks()

        viewModel.searchText = "Clean"
        #expect(viewModel.filteredNews.count == 1)
        #expect(viewModel.filteredNews.first?.title == "iOS Clean Architecture")
    }
}
