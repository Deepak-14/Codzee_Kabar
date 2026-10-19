//
//  NewsCategory.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public struct NewsCategory: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public var isSelected: Bool

    public init(id: String, title: String, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
