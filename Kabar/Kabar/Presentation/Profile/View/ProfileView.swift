//
//  ProfileView.swift
//  Kabar
//
//  Created by user on 11/08/26.
//

import SwiftUI

public struct ProfileView: View {
    @Binding public var path: NavigationPath
    @State private var profileViewModel: ProfileViewModel
    @Environment(AppState.self) private var appState

    public init(
        path: Binding<NavigationPath>,
        viewModel: ProfileViewModel? = nil
    ) {
        _path = path
        _profileViewModel = State(initialValue: viewModel ?? AppDIContainer.shared.makeProfileViewModel())
    }

    public var body: some View {
        VStack {
            Form {
                Text("User Email: \(profileViewModel.email)")
                Button(role: .destructive) {
                    userLogout()
                } label: {
                    Text(AppMessages.textLogout)
                }
            }
            .navigationTitle(AppMessages.textProfile)
            .navigationBarHidden(false)
        }
        .onAppear {
            profileViewModel.fetchUser()
        }
    }

    private func userLogout() {
        Task {
            let isLoggedOut = await profileViewModel.userLogout()
            if isLoggedOut {
                appState.logout()
            }
        }
    }
}
