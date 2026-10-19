//
//  AppState.swift
//  Kabar
//
//  Created by user on 22/08/26.
//

import Observation
import SwiftData
import SwiftUI

@Observable
final class AppState: @unchecked Sendable {
    var isUserLogin: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    func setUserLogin(isLogin: Bool) {
        UserDefaults.standard.set(isLogin, forKey: "isUserLoggedIn")
        isUserLogin = isLogin
    }

    func isUserLoggedIn() -> Bool {
        return isUserLogin
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
        isUserLogin = false
    }
}
