//
//  NewsArticleSave.swift
//  Kabar
//
//  Created by user on 24/08/26.
//

import Foundation
import SwiftData

@Model
public final class NewsArticleSave {
    public var id: UUID
    public var articleURL: String
    public var title: String?
    public var articleDescription: String?
    public var imageURL: String?
    public var author: String?
    public var publishedAt: String?
    public var content: String?

    public init(
        id: UUID = UUID(),
        articleURL: String,
        title: String?,
        articleDescription: String?,
        imageURL: String?,
        author: String?,
        publishedAt: String?,
        content: String?
    ) {
        self.id = id
        self.articleURL = articleURL
        self.title = title
        self.articleDescription = articleDescription
        self.imageURL = imageURL
        self.author = author
        self.publishedAt = publishedAt
        self.content = content
    }

    public convenience init(from article: Article) {
        self.init(
            id: article.id,
            articleURL: article.url ?? "",
            title: article.title,
            articleDescription: article.description,
            imageURL: article.urlToImage,
            author: article.author,
            publishedAt: article.publishedAt,
            content: article.content
        )
    }

    public func toDomain() -> Article {
        return Article(
            id: id,
            source: nil,
            author: author,
            title: title,
            description: articleDescription,
            url: articleURL,
            urlToImage: imageURL,
            publishedAt: publishedAt,
            content: content
        )
    }
}
