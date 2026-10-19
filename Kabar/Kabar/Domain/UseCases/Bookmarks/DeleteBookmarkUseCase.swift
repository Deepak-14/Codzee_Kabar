//
//  DeleteBookmarkUseCase.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol DeleteBookmarkUseCaseProtocol: Sendable {
    func execute(id: UUID) async throws
}

public final class DeleteBookmarkUseCase: DeleteBookmarkUseCaseProtocol {
    private let repository: BookmarkRepositoryProtocol

    public init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: UUID) async throws {
        try await repository.deleteArticle(id: id)
    }
}
