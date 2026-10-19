//
//  LoginView.swift
//  Kabar
//
//  Created by user on 09/08/26.
//

import SwiftUI

public struct LoginView: View {
    @State public var loginViewModel: LoginViewModel
    @Binding public var path: NavigationPath
    @State private var isValid: Bool = false
    @State private var isPasswordVisible: Bool = false
    @Environment(AppState.self) private var appState

    public init(
        path: Binding<NavigationPath>,
        loginViewModel: LoginViewModel? = nil
    ) {
        _path = path
        _loginViewModel = State(initialValue: loginViewModel ?? AppDIContainer.shared.makeLoginViewModel())
    }

    public var body: some View {
        @Bindable var vm = loginViewModel

        VStack(alignment: .leading) {
            // Set Top Text Design
            LoginTitle()

            Spacer()

            // Email Field
            Group {
                Text(AppMessages.textLoginUsername)
                    .modifier(TextFieldTitledModifier())
                TextField("Email", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .frame(height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.colorGrayPurple, lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
            }

            // Password Field
            VStack(alignment: .leading) {
                Text(AppMessages.textLoginPassword)
                    .modifier(TextFieldTitledModifier())
                HStack(alignment: .center) {
                    if isPasswordVisible {
                        TextField("Password", text: $vm.password)
                            .keyboardType(.default)
                    } else {
                        SecureField("Password", text: $vm.password)
                            .keyboardType(.default)
                    }

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                    }
                    .padding(.trailing, 10)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.colorGrayPurple, lineWidth: 1)
                )
                .padding(.horizontal, 24)
            }

            // Forgot Password Section
            HStack {
                Spacer()
                Button {
                    // Forgot password action
                } label: {
                    Text(AppMessages.textLoginForgotPassword)
                        .foregroundColor(.colorBlue)
                }
            }
            .padding(.trailing, 24)
            .padding(.top, 10)

            Spacer()

            // Bottom Login Button
            Button {
                isValid = !vm.validate()
                if !isValid {
                    Task {
                        let success = await vm.login()
                        if success {
                            appState.setUserLogin(isLogin: true)
                            if path.count > 0 {
                                path.removeLast()
                            }
                            path.append(AuthRoute.dashboard)
                        } else {
                            isValid = true
                        }
                    }
                }
            } label: {
                if vm.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(minWidth: 300, maxWidth: .infinity, maxHeight: 48)
                } else {
                    Text("Login")
                        .foregroundColor(.colorWhite)
                        .frame(minWidth: 300, maxWidth: .infinity, maxHeight: 48)
                }
            }
            .background(.colorBlue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .padding(.horizontal, 24)

            Spacer()
        }
        .alert("Alert", isPresented: $isValid) {
            Button("OK", role: .cancel) {
                isValid = false
            }
        } message: {
            Text((loginViewModel.emailError ?? "") + (loginViewModel.passwordError ?? ""))
        }
    }
}

public struct TextFieldModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .frame(height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.colorGrayPurple, lineWidth: 1)
            )
            .padding(.leading, 24)
    }
}

public struct TextFieldTitledModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .frame(alignment: .leading)
            .padding(.horizontal, 24)
            .foregroundColor(.colorGrayPurple)
    }
}

public struct LoginTitle: View {
    public init() {}
    public var body: some View {
        Text(AppMessages.textLoginHello)
            .font(Font.system(size: 48))
            .fontWeight(.bold)
            .foregroundColor(.colorBlackLight)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 5, trailing: 0))

        Text(AppMessages.textLoginAgain)
            .font(Font.system(size: 48))
            .fontWeight(.bold)
            .foregroundColor(.colorBlue)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 10, trailing: 0))

        Text(AppMessages.textLoginWelcomBack)
            .font(Font.system(size: 20))
            .fontWeight(.regular)
            .foregroundColor(.colorGrayPurple)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 10, trailing: 0))
            .lineLimit(2)
            .frame(width: 220)
    }
}
