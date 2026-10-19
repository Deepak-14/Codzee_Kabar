//
//  MainTabView.swift
//  Kabar
//
//  Created by user on 11/08/26.
//

import SwiftUI

public enum Tab: Hashable {
    case home
    case explore
    case bookmark
    case profile
}

public struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var pathHome = NavigationPath()
    @State private var pathExplore = NavigationPath()
    @State private var pathBookMark = NavigationPath()
    @State private var pathProfile = NavigationPath()

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $pathHome) {
                HomeView(path: $pathHome)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Image(selectedTab == .home ? "icon_home_selected" : "icon_home_unselected")
                Text(AppMessages.textHome)
            }
            .tag(Tab.home)

            NavigationStack(path: $pathExplore) {
                ExploreView(path: $pathExplore)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Image(selectedTab == .explore ? "icon_explore_selected" : "icon_explore_unselected")
                Text(AppMessages.textExplore)
            }
            .tag(Tab.explore)

            NavigationStack(path: $pathBookMark) {
                BookmarkView(path: $pathBookMark)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Image(selectedTab == .bookmark ? "icon_bookmark_select" : "icon_bookmark_unselect")
                Text(AppMessages.textBookMark)
            }
            .tag(Tab.bookmark)

            NavigationStack(path: $pathProfile) {
                ProfileView(path: $pathProfile)
            }
            .tabItem {
                Image(selectedTab == .profile ? "icon_profile_selected" : "icon_profile_unselected")
                Text(AppMessages.textProfile)
            }
            .tag(Tab.profile)
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .newsDetail(let article):
            NewsDetails(news: article)
        }
    }
}
