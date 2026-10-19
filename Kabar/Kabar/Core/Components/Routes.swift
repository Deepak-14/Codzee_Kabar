//
//  Routes.swift
//  Kabar
//
//  Created by user on 10/08/26.
//

import Foundation

public enum AuthRoute: Hashable {
    case login
    case dashboard
}

public enum AppRoute: Hashable {
    case newsDetail(Article)
}
