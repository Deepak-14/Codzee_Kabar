//
//  AuthRepositoryProtocol.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public protocol AuthRepositoryProtocol: Sendable {
    func authenticate(email: String, password: String) async throws -> User
    func logout() async throws
    func getCurrentUser() -> User?
    func isUserLoggedIn() -> Bool
}
