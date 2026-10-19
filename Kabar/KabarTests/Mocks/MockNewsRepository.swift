//
//  MockNewsRepository.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Foundation
@testable import Kabar

final class MockNewsRepository: NewsRepositoryProtocol, @unchecked Sendable {
    var stubbedArticles: [Article] = []
    var shouldThrowError: Error?
    var receivedQuery: String?

    func fetchNews(query: String) async throws -> [Article] {
        receivedQuery = query
        if let error = shouldThrowError {
            throw error
        }
        return stubbedArticles
    }
}
