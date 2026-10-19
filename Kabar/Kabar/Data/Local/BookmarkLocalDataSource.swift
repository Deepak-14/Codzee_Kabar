//
//  BookmarkLocalDataSource.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation
import SwiftData

@MainActor
public protocol BookmarkLocalDataSourceProtocol: AnyObject {
    func fetchAll() throws -> [NewsArticleSave]
    func fetch(by id: UUID) throws -> NewsArticleSave?
    func save(_ entity: NewsArticleSave) throws
    func delete(id: UUID) throws
    func setModelContext(_ context: ModelContext)
}

@MainActor
public final class BookmarkLocalDataSource: BookmarkLocalDataSourceProtocol {
    private var modelContext: ModelContext?

    public init(modelContext: ModelContext? = nil) {
        if let modelContext = modelContext {
            self.modelContext = modelContext
        } else {
            // Attempt to create a default in-memory or standard container if none provided
            if let container = try? ModelContainer(for: NewsArticleSave.self) {
                self.modelContext = container.mainContext
            }
        }
    }

    public func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    private func getContext() throws -> ModelContext {
        guard let context = modelContext else {
            throw DomainError.storageError("ModelContext is not configured")
        }
        return context
    }

    public func fetchAll() throws -> [NewsArticleSave] {
        let context = try getContext()
        let descriptor = FetchDescriptor<NewsArticleSave>(
            sortBy: [SortDescriptor(\.publishedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    public func fetch(by id: UUID) throws -> NewsArticleSave? {
        let context = try getContext()
        let descriptor = FetchDescriptor<NewsArticleSave>(
            predicate: #Predicate { article in
                article.id == id
            }
        )
        return try context.fetch(descriptor).first
    }

    public func save(_ entity: NewsArticleSave) throws {
        let context = try getContext()
        context.insert(entity)
        try context.save()
    }

    public func delete(id: UUID) throws {
        let context = try getContext()
        if let existing = try fetch(by: id) {
            context.delete(existing)
            try context.save()
        }
    }
}
