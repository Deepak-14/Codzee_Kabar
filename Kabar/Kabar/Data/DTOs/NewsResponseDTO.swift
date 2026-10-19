//
//  NewsResponseDTO.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public struct NewsResponseDTO: Codable, Sendable {
    public let status: String?
    public let totalResults: Int?
    public let articles: [ArticleDTO]?

    public init(status: String? = nil, totalResults: Int? = nil, articles: [ArticleDTO]? = nil) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}
