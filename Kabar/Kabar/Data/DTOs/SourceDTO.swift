//
//  SourceDTO.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public struct SourceDTO: Codable, Sendable {
    public let id: String?
    public let name: String?

    public init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }

    public func toDomain() -> NewsSource {
        return NewsSource(id: id, name: name)
    }
}
