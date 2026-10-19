//
//  DTOMappingTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

struct DTOMappingTests {
    @Test func testArticleDTOMapping() {
        let sourceDTO = SourceDTO(id: "the-verge", name: "The Verge")
        let articleDTO = ArticleDTO(
            source: sourceDTO,
            author: "Alex",
            title: "New AI Hardware",
            description: "A comprehensive look",
            url: "https://theverge.com/ai",
            urlToImage: "https://theverge.com/img.png",
            publishedAt: "2026-10-19T10:00:00Z",
            content: "Full content here"
        )

        let domainArticle = articleDTO.toDomain()

        #expect(domainArticle.title == "New AI Hardware")
        #expect(domainArticle.author == "Alex")
        #expect(domainArticle.source?.name == "The Verge")
        #expect(domainArticle.source?.id == "the-verge")
        #expect(domainArticle.url == "https://theverge.com/ai")
    }

    @Test func testNewsArticleSaveMapping() {
        let article = Article(
            id: UUID(),
            author: "Reporter",
            title: "Breaking News Headline",
            description: "Details of breaking news",
            url: "https://news.com/breaking",
            urlToImage: "https://news.com/img.jpg",
            publishedAt: "2026-10-19",
            content: "Content..."
        )

        let entity = NewsArticleSave(from: article)
        #expect(entity.id == article.id)
        #expect(entity.title == article.title)
        #expect(entity.articleURL == article.url)

        let mappedBack = entity.toDomain()
        #expect(mappedBack.id == article.id)
        #expect(mappedBack.title == article.title)
        #expect(mappedBack.url == article.url)
    }
}
