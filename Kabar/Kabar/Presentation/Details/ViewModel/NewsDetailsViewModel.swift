//
//  NewsDetailsViewModel.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
public final class NewsDetailsViewModel {
    private let checkIsBookmarkedUseCase: CheckIsBookmarkedUseCaseProtocol
    private let toggleBookmarkUseCase: ToggleBookmarkUseCaseProtocol

    public var article: Article?
    public var isNewsSaved: Bool = false
    public var errorMessage: String?

    public init(
        article: Article?,
        checkIsBookmarkedUseCase: CheckIsBookmarkedUseCaseProtocol,
        toggleBookmarkUseCase: ToggleBookmarkUseCaseProtocol
    ) {
        self.article = article
        self.checkIsBookmarkedUseCase = checkIsBookmarkedUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func checkBookmarkStatus() async {
        guard let article = article else { return }
        do {
            self.isNewsSaved = try await checkIsBookmarkedUseCase.execute(id: article.id)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    public func toggleBookmark() async {
        guard let article = article else { return }
        do {
            self.isNewsSaved = try await toggleBookmarkUseCase.execute(article: article)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
