//
//  NewsRemoteDataSource.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol NewsRemoteDataSourceProtocol: Sendable {
    func fetchNews(query: String) async throws -> [ArticleDTO]
}

public final class NewsRemoteDataSource: NewsRemoteDataSourceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseUrl: String
    private let apiKey: String

    public init(
        networkManager: NetworkManagerProtocol,
        baseUrl: String = APIConstant.baseUrl,
        apiKey: String = APIConstant.apiKey
    ) {
        self.networkManager = networkManager
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }

    public func fetchNews(query: String) async throws -> [ArticleDTO] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseUrl)everything?q=\(encodedQuery)&apiKey=\(apiKey)"

        let response: NewsResponseDTO = try await networkManager.request(
            NewsResponseDTO.self,
            url: urlString,
            method: .get
        )

        return response.articles ?? []
    }
}
