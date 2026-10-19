//
//  MockAuthRepository.swift
//  KabarTests
//
//  Created by user on 19/10/26.
//

import Foundation
@testable import Kabar

final class MockAuthRepository: AuthRepositoryProtocol, @unchecked Sendable {
    var stubbedUser: User? = User(id: "user_123", email: "test@kabar.com")
    var shouldThrowError: Error?
    var isLoggedIn: Bool = false

    func authenticate(email: String, password: String) async throws -> User {
        if let error = shouldThrowError {
            throw error
        }
        let user = stubbedUser ?? User(id: "user_123", email: email)
        isLoggedIn = true
        return user
    }

    func logout() async throws {
        if let error = shouldThrowError {
            throw error
        }
        isLoggedIn = false
        stubbedUser = nil
    }

    func getCurrentUser() -> User? {
        return stubbedUser
    }

    func isUserLoggedIn() -> Bool {
        return isLoggedIn
    }
}
