//
//  AppDIContainer.swift
//  Kabar
//
//  Created by user on 19/10/26.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
public final class AppDIContainer {
    public static let shared = AppDIContainer()

    // MARK: - Core & Data Sources
    public let networkManager: NetworkManagerProtocol
    public let newsRemoteDataSource: NewsRemoteDataSourceProtocol
    public let bookmarkLocalDataSource: BookmarkLocalDataSourceProtocol
    public let authRemoteDataSource: AuthRemoteDataSourceProtocol

    // MARK: - Repositories
    public let newsRepository: NewsRepositoryProtocol
    public let bookmarkRepository: BookmarkRepositoryProtocol
    public let authRepository: AuthRepositoryProtocol

    // MARK: - Use Cases
    public let fetchNewsUseCase: FetchNewsUseCaseProtocol
    public let filterNewsUseCase: FilterNewsUseCaseProtocol
    public let getBookmarksUseCase: GetBookmarksUseCaseProtocol
    public let saveBookmarkUseCase: SaveBookmarkUseCaseProtocol
    public let deleteBookmarkUseCase: DeleteBookmarkUseCaseProtocol
    public let checkIsBookmarkedUseCase: CheckIsBookmarkedUseCaseProtocol
    public let toggleBookmarkUseCase: ToggleBookmarkUseCaseProtocol
    public let authenticateUseCase: AuthenticateUseCaseProtocol
    public let logoutUseCase: LogoutUseCaseProtocol
    public let getCurrentUserUseCase: GetCurrentUserUseCaseProtocol

    public init(
        networkManager: NetworkManagerProtocol,
        bookmarkLocalDataSource: BookmarkLocalDataSourceProtocol,
        authRemoteDataSource: AuthRemoteDataSourceProtocol
    ) {
        self.networkManager = networkManager
        self.bookmarkLocalDataSource = bookmarkLocalDataSource
        self.authRemoteDataSource = authRemoteDataSource

        // Remote Data Sources
        self.newsRemoteDataSource = NewsRemoteDataSource(networkManager: networkManager)

        // Repositories
        let newsRepo = NewsRepository(remoteDataSource: self.newsRemoteDataSource)
        let bookmarkRepo = BookmarkRepository(localDataSource: bookmarkLocalDataSource)
        let authRepo = AuthRepository(remoteDataSource: authRemoteDataSource)

        self.newsRepository = newsRepo
        self.bookmarkRepository = bookmarkRepo
        self.authRepository = authRepo

        // Use Cases
        self.fetchNewsUseCase = FetchNewsUseCase(repository: newsRepo)
        self.filterNewsUseCase = FilterNewsUseCase()
        self.getBookmarksUseCase = GetBookmarksUseCase(repository: bookmarkRepo)
        self.saveBookmarkUseCase = SaveBookmarkUseCase(repository: bookmarkRepo)
        self.deleteBookmarkUseCase = DeleteBookmarkUseCase(repository: bookmarkRepo)
        self.checkIsBookmarkedUseCase = CheckIsBookmarkedUseCase(repository: bookmarkRepo)
        self.toggleBookmarkUseCase = ToggleBookmarkUseCase(repository: bookmarkRepo)
        self.authenticateUseCase = AuthenticateUseCase(repository: authRepo)
        self.logoutUseCase = LogoutUseCase(repository: authRepo)
        self.getCurrentUserUseCase = GetCurrentUserUseCase(repository: authRepo)
    }

    public convenience init() {
        self.init(
            networkManager: NetworkManager(),
            bookmarkLocalDataSource: BookmarkLocalDataSource(),
            authRemoteDataSource: FirebaseAuthRemoteDataSource()
        )
    }

    public func configureModelContext(_ context: ModelContext) {
        bookmarkLocalDataSource.setModelContext(context)
    }

    // MARK: - ViewModel Factories
    public func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchNewsUseCase: fetchNewsUseCase,
            filterNewsUseCase: filterNewsUseCase
        )
    }

    public func makeExploreViewModel() -> ExploreViewModel {
        ExploreViewModel(
            fetchNewsUseCase: fetchNewsUseCase,
            filterNewsUseCase: filterNewsUseCase,
            toggleBookmarkUseCase: toggleBookmarkUseCase,
            checkIsBookmarkedUseCase: checkIsBookmarkedUseCase
        )
    }

    public func makeBookmarkViewModel() -> BookmarkViewModel {
        BookmarkViewModel(
            getBookmarksUseCase: getBookmarksUseCase,
            deleteBookmarkUseCase: deleteBookmarkUseCase
        )
    }

    public func makeNewsDetailsViewModel(article: Article?) -> NewsDetailsViewModel {
        NewsDetailsViewModel(
            article: article,
            checkIsBookmarkedUseCase: checkIsBookmarkedUseCase,
            toggleBookmarkUseCase: toggleBookmarkUseCase
        )
    }

    public func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authenticateUseCase: authenticateUseCase)
    }

    public func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            getCurrentUserUseCase: getCurrentUserUseCase,
            logoutUseCase: logoutUseCase
        )
    }
}
