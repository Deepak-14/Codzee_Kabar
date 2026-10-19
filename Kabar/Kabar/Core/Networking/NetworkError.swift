//
//  NetworkError.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(String)
    case serverError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse(let statusCode):
            return "Server returned an invalid response with status code: \(statusCode)."
        case .noData:
            return "No data received from the server."
        case .decodingError(let message):
            return "Failed to decode data: \(message)"
        case .serverError(let message):
            return message
        }
    }
}
