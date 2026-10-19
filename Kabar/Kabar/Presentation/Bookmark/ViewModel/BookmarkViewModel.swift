//
//  BookmarkViewModel.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
public final class BookmarkViewModel {
    private let getBookmarksUseCase: GetBookmarksUseCaseProtocol
    private let deleteBookmarkUseCase: DeleteBookmarkUseCaseProtocol

    public var savedNews: [Article] = []
    public var searchText: String = ""
    public var isLoading: Bool = false
    public var errorMessage: String?

    public init(
        getBookmarksUseCase: GetBookmarksUseCaseProtocol,
        deleteBookmarkUseCase: DeleteBookmarkUseCaseProtocol
    ) {
        self.getBookmarksUseCase = getBookmarksUseCase
        self.deleteBookmarkUseCase = deleteBookmarkUseCase
    }

    public func fetchAllBookmarks() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            self.savedNews = try await getBookmarksUseCase.execute()
        } catch {
            self.errorMessage = error.localizedDescription
            print("Failed to fetch bookmarks: \(error)")
        }
    }

    public func deleteBookmark(id: UUID) async {
        do {
            try await deleteBookmarkUseCase.execute(id: id)
            savedNews.removeAll { $0.id == id }
        } catch {
            self.errorMessage = error.localizedDescription
            print("Failed to delete bookmark: \(error)")
        }
    }

    public var filteredNews: [Article] {
        let search = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if search.isEmpty {
            return savedNews
        }

        return savedNews.filter { article in
            article.title?.localizedCaseInsensitiveContains(search) == true
            ||
            article.description?.localizedCaseInsensitiveContains(search) == true
            ||
            article.author?.localizedCaseInsensitiveContains(search) == true
        }
    }
}
