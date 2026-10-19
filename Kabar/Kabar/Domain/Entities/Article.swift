//
//  Article.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public struct Article: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let source: NewsSource?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?

    public init(
        id: UUID = UUID(),
        source: NewsSource? = nil,
        author: String? = nil,
        title: String? = nil,
        description: String? = nil,
        url: String? = nil,
        urlToImage: String? = nil,
        publishedAt: String? = nil,
        content: String? = nil
    ) {
        self.id = id
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}
