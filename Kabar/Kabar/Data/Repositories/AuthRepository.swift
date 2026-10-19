//
//  AuthRepository.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation

public final class AuthRepository: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let userDefaultsKey = "isUserLoggedIn"

    public init(remoteDataSource: AuthRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    public func authenticate(email: String, password: String) async throws -> User {
        let user = try await remoteDataSource.authenticate(email: email, password: password)
        UserDefaults.standard.set(true, forKey: userDefaultsKey)
        return user
    }

    public func logout() async throws {
        try remoteDataSource.logout()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }

    public func getCurrentUser() -> User? {
        return remoteDataSource.getCurrentUser()
    }

    public func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: userDefaultsKey) && remoteDataSource.getCurrentUser() != nil
    }
}
