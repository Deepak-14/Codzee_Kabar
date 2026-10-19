//
//  FetchNewsUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol FetchNewsUseCaseProtocol: Sendable {
    func execute(query: String) async throws -> [Article]
}

public final class FetchNewsUseCase: FetchNewsUseCaseProtocol {
    private let repository: NewsRepositoryProtocol

    public init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(query: String) async throws -> [Article] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let effectiveQuery = trimmedQuery.isEmpty ? "bitcoin" : trimmedQuery
        return try await repository.fetchNews(query: effectiveQuery)
    }
}
