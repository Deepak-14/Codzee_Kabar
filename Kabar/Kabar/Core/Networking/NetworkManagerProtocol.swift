//
//  NetworkManagerProtocol.swift
//  Kabar
//
//  Created by user on 22/08/26.
//

import Foundation

public enum APIMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
}

public protocol NetworkManagerProtocol: Sendable {
    func request<T: Decodable>(_ type: T.Type, url: String, method: APIMethod) async throws -> T
}
