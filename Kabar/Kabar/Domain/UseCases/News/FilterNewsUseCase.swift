//
//  FilterNewsUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol FilterNewsUseCaseProtocol: Sendable {
    func filterArticles(_ articles: [Article], source: String, searchText: String) -> [Article]
    func makeCategories(from articles: [Article], selectedSource: String) -> [NewsCategory]
}

public final class FilterNewsUseCase: FilterNewsUseCaseProtocol {
    public init() {}

    public func filterArticles(_ articles: [Article], source: String, searchText: String) -> [Article] {
        var result = articles

        // Source filtering
        if source != "All" {
            result = result.filter { $0.source?.name == source }
        }

        // Search filtering
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedSearch.isEmpty {
            result = result.filter { article in
                article.title?.localizedCaseInsensitiveContains(trimmedSearch) == true
                ||
                article.description?.localizedCaseInsensitiveContains(trimmedSearch) == true
                ||
                article.author?.localizedCaseInsensitiveContains(trimmedSearch) == true
            }
        }

        return result
    }

    public func makeCategories(from articles: [Article], selectedSource: String) -> [NewsCategory] {
        var headers: [NewsCategory] = [
            NewsCategory(id: "all", title: "All", isSelected: selectedSource == "All")
        ]

        var addedSources = Set<String>()

        for article in articles {
            guard let sourceName = article.source?.name, !sourceName.isEmpty else {
                continue
            }

            if addedSources.insert(sourceName).inserted {
                headers.append(
                    NewsCategory(
                        id: sourceName,
                        title: sourceName,
                        isSelected: selectedSource == sourceName
                    )
                )
            }
        }

        return headers
    }
}
