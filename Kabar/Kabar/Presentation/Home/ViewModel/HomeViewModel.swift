//
//  HomeViewModel.swift
//  Kabar
//
//  Created by user on 22/08/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
public final class HomeViewModel {
    private let fetchNewsUseCase: FetchNewsUseCaseProtocol
    private let filterNewsUseCase: FilterNewsUseCaseProtocol

    public var newsData: [Article] = []
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var selectedSource: String = "All"
    public var searchText: String = ""
    public var newsType: String = "bitcoin"
    public private(set) var hasLoaded: Bool = false

    public init(
        fetchNewsUseCase: FetchNewsUseCaseProtocol,
        filterNewsUseCase: FilterNewsUseCaseProtocol = FilterNewsUseCase()
    ) {
        self.fetchNewsUseCase = fetchNewsUseCase
        self.filterNewsUseCase = filterNewsUseCase
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
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching news: \(error)")
        }
    }

    public var filteredNews: [Article] {
        return filterNewsUseCase.filterArticles(newsData, source: selectedSource, searchText: searchText)
    }

    public func setNewsFilter(_ source: String) {
        selectedSource = source
    }

    public func filterHeaders() -> [NewsCategory] {
        return filterNewsUseCase.makeCategories(from: newsData, selectedSource: selectedSource)
    }
}
