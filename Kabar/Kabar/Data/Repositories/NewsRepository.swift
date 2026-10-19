//
//  NewsRepository.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public final class NewsRepository: NewsRepositoryProtocol {
    private let remoteDataSource: NewsRemoteDataSourceProtocol

    public init(remoteDataSource: NewsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    public func fetchNews(query: String) async throws -> [Article] {
        let dtos = try await remoteDataSource.fetchNews(query: query)
        return dtos.map { $0.toDomain() }
    }
}
