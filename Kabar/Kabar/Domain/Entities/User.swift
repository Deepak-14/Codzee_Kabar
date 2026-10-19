//
//  User.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public struct User: Identifiable, Hashable, Sendable {
    public let id: String
    public let email: String?

    public init(id: String, email: String?) {
        self.id = id
        self.email = email
    }
}
