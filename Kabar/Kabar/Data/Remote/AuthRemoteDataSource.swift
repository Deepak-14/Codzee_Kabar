//
//  AuthRemoteDataSource.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation
import FirebaseAuth

public protocol AuthRemoteDataSourceProtocol: Sendable {
    func authenticate(email: String, password: String) async throws -> User
    func logout() throws
    func getCurrentUser() -> User?
}

public final class FirebaseAuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    public init() {}

    public func authenticate(email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return User(id: result.user.uid, email: result.user.email)
        } catch let error as NSError {
            // Error code 17007 represents AuthErrorCode.emailAlreadyInUse
            if error.code == 17007 || error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                let signInResult = try await Auth.auth().signIn(withEmail: email, password: password)
                return User(id: signInResult.user.uid, email: signInResult.user.email)
            } else {
                throw DomainError.networkError(error.localizedDescription)
            }
        }
    }

    public func logout() throws {
        try Auth.auth().signOut()
    }

    public func getCurrentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else {
            return nil
        }
        return User(id: firebaseUser.uid, email: firebaseUser.email)
    }
}
