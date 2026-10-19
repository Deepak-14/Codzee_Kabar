//
//  NewsRepositoryProtocol.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol NewsRepositoryProtocol: Sendable {
    func fetchNews(query: String) async throws -> [Article]
}
