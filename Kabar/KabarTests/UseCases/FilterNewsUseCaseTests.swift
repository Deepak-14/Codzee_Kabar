//
//  FilterNewsUseCaseTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

struct FilterNewsUseCaseTests {
    private let useCase = FilterNewsUseCase()

    private let sampleArticles = [
        Article(
            source: NewsSource(id: "bbc", name: "BBC News"),
            author: "John Doe",
            title: "Apple announces new iPhone",
            description: "A major hardware event"
        ),
        Article(
            source: NewsSource(id: "cnn", name: "CNN"),
            author: "Jane Smith",
            title: "Global markets rally",
            description: "Stocks surge worldwide"
        ),
        Article(
            source: NewsSource(id: "bbc", name: "BBC News"),
            author: "Alice",
            title: "Electric vehicle battery breakthrough",
            description: "New tech promises 1000km range"
        )
    ]

    @Test func testFilterBySource() {
        let bbcArticles = useCase.filterArticles(sampleArticles, source: "BBC News", searchText: "")
        #expect(bbcArticles.count == 2)

        let allArticles = useCase.filterArticles(sampleArticles, source: "All", searchText: "")
        #expect(allArticles.count == 3)
    }

    @Test func testFilterBySearchText() {
        let searchResults = useCase.filterArticles(sampleArticles, source: "All", searchText: "iPhone")
        #expect(searchResults.count == 1)
        #expect(searchResults.first?.title == "Apple announces new iPhone")

        let authorSearch = useCase.filterArticles(sampleArticles, source: "All", searchText: "Jane")
        #expect(authorSearch.count == 1)
        #expect(authorSearch.first?.author == "Jane Smith")
    }

    @Test func testMakeCategories() {
        let categories = useCase.makeCategories(from: sampleArticles, selectedSource: "BBC News")
        #expect(categories.count == 3) // "All", "BBC News", "CNN"
        #expect(categories[0].title == "All")
        #expect(categories[0].isSelected == false)
        #expect(categories.contains(where: { $0.title == "BBC News" && $0.isSelected == true }))
    }
}
