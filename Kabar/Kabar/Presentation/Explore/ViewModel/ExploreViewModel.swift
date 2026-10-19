//
//  ExploreViewModel.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
public final class ExploreViewModel {
    private let fetchNewsUseCase: FetchNewsUseCaseProtocol
    private let filterNewsUseCase: FilterNewsUseCaseProtocol
    private let toggleBookmarkUseCase: ToggleBookmarkUseCaseProtocol
    private let checkIsBookmarkedUseCase: CheckIsBookmarkedUseCaseProtocol

    public var newsData: [Article] = []
    public var savedArticleIds: Set<UUID> = []
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var newsType: String = "bitcoin"
    public private(set) var hasLoaded: Bool = false

    public init(
        fetchNewsUseCase: FetchNewsUseCaseProtocol,
        filterNewsUseCase: FilterNewsUseCaseProtocol = FilterNewsUseCase(),
        toggleBookmarkUseCase: ToggleBookmarkUseCaseProtocol,
        checkIsBookmarkedUseCase: CheckIsBookmarkedUseCaseProtocol
    ) {
        self.fetchNewsUseCase = fetchNewsUseCase
        self.filterNewsUseCase = filterNewsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.checkIsBookmarkedUseCase = checkIsBookmarkedUseCase
    }

    public func fetchNewsIfNeeded() async {
        guard !hasLoaded else { return }
        await fetchNews()
    }

    public func fetchNews() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let articles = try await fetchNewsUseCase.execute(query: newsType)
            self.newsData = articles
            self.hasLoaded = true
            await updateSavedStatus()
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching explore news: \(error)")
        }
    }

    public func updateSavedStatus() async {
        var savedSet = Set<UUID>()
        for article in newsData {
            if let isSaved = try? await checkIsBookmarkedUseCase.execute(id: article.id), isSaved {
                savedSet.insert(article.id)
            }
        }
        self.savedArticleIds = savedSet
    }

    public func isBookmarked(_ article: Article) -> Bool {
        return savedArticleIds.contains(article.id)
    }

    public func toggleBookmark(for article: Article) async {
        do {
            let isSaved = try await toggleBookmarkUseCase.execute(article: article)
            if isSaved {
                savedArticleIds.insert(article.id)
            } else {
                savedArticleIds.remove(article.id)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
