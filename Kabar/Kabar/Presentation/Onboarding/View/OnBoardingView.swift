//
//  OnBoardingView.swift
//  Kabar
//
//  Created by user on 09/08/26.
//

import SwiftUI

public struct OnBoardingView: View {
    @State private var pageCount = 0
    private let views = ["icon_onboarding_1", "icon_onboarding_2", "icon_onboarding_3"]
    @State private var path = NavigationPath()

    public init() {}

    public var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack {
                    TabView(selection: $pageCount) {
                        ForEach(0..<views.count, id: \.self) { index in
                            Image(views[index])
                                .resizable()
                                .scaledToFill()
                                .tag(index)
                                .frame(height: 700)
                        }
                    }
                    .tabViewStyle(
                        PageTabViewStyle(indexDisplayMode: .never)
                    )
                    .tabViewStyle(.page)
                }
                .frame(height: 600)

                VStack(spacing: 8) {
                    Text(AppMessages.textOnBoardingTitle1)
                        .foregroundColor(.colorBlack)
                        .font(Font.system(size: 24))
                        .fontWeight(.bold)

                    Text(AppMessages.textOnBoardingSubTitle1)
                        .foregroundColor(.colorGrayPurple)
                        .font(Font.system(size: 16))
                        .fontWeight(.regular)
                        .lineLimit(2)
                }
                .padding()

                Spacer()

                HStack {
                    ForEach(0..<views.count, id: \.self) { index in
                        Circle()
                            .fill(pageCount == index ? .colorBlue : .colorGrayPurpleLight)
                            .frame(width: 8, height: 8)
                            .scaleEffect(pageCount == index ? 1.2 : 1.0)
                            .animation(.spring(), value: pageCount)
                    }

                    Spacer()

                    if pageCount > 0 {
                        Button {
                            pageCount -= 1
                        } label: {
                            Text("Back")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 50, height: 40)
                    }

                    Button {
                        if pageCount >= 2 {
                            if path.count > 0 {
                                path.removeLast()
                            }
                            path.append(AuthRoute.login)
                        } else {
                            pageCount += 1
                        }
                    } label: {
                        Text(pageCount >= 2 ? "Get Started" : "Next")
                            .background(.blue)
                            .foregroundColor(.white)
                            .padding(15)
                    }
                    .background(.blue)
                    .clipShape(.buttonBorder)
                }
                .padding(20)
            }
            .ignoresSafeArea()
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .login:
                    LoginView(path: $path)
                case .dashboard:
                    MainTabView()
                }
            }
        }
    }
}
