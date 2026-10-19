//
//  DomainError.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public enum DomainError: LocalizedError, Equatable {
    case invalidCredentials
    case userNotFound
    case validationError(String)
    case networkError(String)
    case storageError(String)
    case emptySearchQuery
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password."
        case .userNotFound:
            return "User not found."
        case .validationError(let message):
            return message
        case .networkError(let message):
            return message
        case .storageError(let message):
            return message
        case .emptySearchQuery:
            return "Search query cannot be empty."
        case .unknown(let message):
            return message
        }
    }
}
