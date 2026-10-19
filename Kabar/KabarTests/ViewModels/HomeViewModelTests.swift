//
//  HomeViewModelTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

@MainActor
struct HomeViewModelTests {
    @Test func testFetchNewsPopulatesArticles() async {
        let mockRepo = MockNewsRepository()
        let sample = Article(
            id: UUID(),
            source: NewsSource(id: "tech", name: "TechCrunch"),
            title: "Swift 6 Released",
            description: "Exciting new concurrency features"
        )
        mockRepo.stubbedArticles = [sample]

        let fetchUseCase = FetchNewsUseCase(repository: mockRepo)
        let filterUseCase = FilterNewsUseCase()
        let viewModel = HomeViewModel(fetchNewsUseCase: fetchUseCase, filterNewsUseCase: filterUseCase)

        #expect(viewModel.newsData.isEmpty)
        #expect(viewModel.hasLoaded == false)

        await viewModel.fetchNews()

        #expect(viewModel.newsData.count == 1)
        #expect(viewModel.hasLoaded == true)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.filteredNews.count == 1)
    }

    @Test func testFilteringBySourceAndSearch() async {
        let mockRepo = MockNewsRepository()
        let article1 = Article(
            id: UUID(),
            source: NewsSource(id: "tech", name: "TechCrunch"),
            title: "Swift Concurrency",
            description: "Actor isolation deep dive"
        )
        let article2 = Article(
            id: UUID(),
            source: NewsSource(id: "crypto", name: "CoinDesk"),
            title: "Bitcoin Update",
            description: "Market movements"
        )
        mockRepo.stubbedArticles = [article1, article2]

        let fetchUseCase = FetchNewsUseCase(repository: mockRepo)
        let filterUseCase = FilterNewsUseCase()
        let viewModel = HomeViewModel(fetchNewsUseCase: fetchUseCase, filterNewsUseCase: filterUseCase)

        await viewModel.fetchNews()

        // Filter by source
        viewModel.setNewsFilter("CoinDesk")
        #expect(viewModel.filteredNews.count == 1)
        #expect(viewModel.filteredNews.first?.title == "Bitcoin Update")

        // Filter by search
        viewModel.setNewsFilter("All")
        viewModel.searchText = "Swift"
        #expect(viewModel.filteredNews.count == 1)
        #expect(viewModel.filteredNews.first?.title == "Swift Concurrency")
    }
}
