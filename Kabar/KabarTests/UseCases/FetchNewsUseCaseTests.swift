//
//  FetchNewsUseCaseTests.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Testing
import Foundation
@testable import Kabar

struct FetchNewsUseCaseTests {
    @Test func testFetchNewsSuccess() async throws {
        let mockRepo = MockNewsRepository()
        let expectedArticle = Article(
            id: UUID(),
            title: "Bitcoin Soars",
            description: "Crypto market update"
        )
        mockRepo.stubbedArticles = [expectedArticle]

        let useCase = FetchNewsUseCase(repository: mockRepo)
        let articles = try await useCase.execute(query: "crypto")

        #expect(articles.count == 1)
        #expect(articles.first?.title == "Bitcoin Soars")
        #expect(mockRepo.receivedQuery == "crypto")
    }

    @Test func testFetchNewsWithEmptyQueryDefaultsToBitcoin() async throws {
        let mockRepo = MockNewsRepository()
        mockRepo.stubbedArticles = []

        let useCase = FetchNewsUseCase(repository: mockRepo)
        _ = try await useCase.execute(query: "   ")

        #expect(mockRepo.receivedQuery == "bitcoin")
    }

    @Test func testFetchNewsFailureThrowsError() async {
        let mockRepo = MockNewsRepository()
        let expectedError = DomainError.networkError("Failed to connect")
        mockRepo.shouldThrowError = expectedError

        let useCase = FetchNewsUseCase(repository: mockRepo)

        await #expect(throws: expectedError) {
            _ = try await useCase.execute(query: "tech")
        }
    }
}
