//
//  AppContainer.swift
//  Kabar
//
//  Created by user on 05/08/26.
//

import SwiftUI
import SwiftData

struct AppContainer: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if appState.isUserLogin {
                NavigationStack {
                    MainTabView()
                }
            } else {
                OnBoardingView()
            }
        }
        .onAppear {
            AppDIContainer.shared.configureModelContext(modelContext)
        }
    }
}

#Preview {
    AppContainer()
        .environment(AppState())
}
