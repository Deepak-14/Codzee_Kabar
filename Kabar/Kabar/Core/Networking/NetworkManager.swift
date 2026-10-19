//
//  NetworkManager.swift
//  Kabar
//
//  Created by user on 22/08/26.
//

import Foundation

public final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(_ type: T.Type, url: String, method: APIMethod = .get) async throws -> T {
        guard let requestUrl = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = method.rawValue

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}
