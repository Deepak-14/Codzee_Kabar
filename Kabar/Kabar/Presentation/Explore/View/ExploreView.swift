//
//  ExploreView.swift
//  Kabar
//
//  Created by user on 11/08/26.
//

import SwiftUI

public struct ExploreView: View {
    @State private var viewModel: ExploreViewModel
    @Binding var path: NavigationPath

    public init(
        path: Binding<NavigationPath>,
        viewModel: ExploreViewModel? = nil
    ) {
        _path = path
        _viewModel = State(initialValue: viewModel ?? AppDIContainer.shared.makeExploreViewModel())
    }

    public var body: some View {
        @Bindable var vm = viewModel

        VStack {
            if vm.isLoading && vm.newsData.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                List {
                    Section {
                        ForEach(vm.newsData.prefix(3)) { news in
                            Button {
                                if path.count > 0 {
                                    path.removeLast()
                                }
                                path.append(AppRoute.newsDetail(news))
                            } label: {
                                ExploreCell(
                                    imgUrl: news.urlToImage ?? "",
                                    title: news.title ?? "",
                                    newsDescription: news.description ?? "",
                                    isSaved: vm.isBookmarked(news)
                                ) {
                                    Task {
                                        await vm.toggleBookmark(for: news)
                                    }
                                }
                            }
                        }
                    } header: {
                        HeaderTitleView(
                            headername: AppMessages.textTopic,
                            seeAll: AppMessages.textSeeAll,
                            isSeeAllActive: true
                        )
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)

                    Section {
                        ForEach(vm.newsData) { news in
                            Button {
                                if path.count > 0 {
                                    path.removeLast()
                                }
                                path.append(AppRoute.newsDetail(news))
                            } label: {
                                TrandingNewsCell(
                                    imgUrl: news.urlToImage ?? "",
                                    title: news.title ?? "",
                                    newsDescription: news.description ?? "",
                                    lineLimitDetail: true,
                                    lineLimitTitle: true
                                )
                            }
                        }
                    } header: {
                        HeaderTitleView(
                            headername: AppMessages.textPopularTopic,
                            seeAll: AppMessages.textSeeAll,
                            isSeeAllActive: false
                        )
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle(AppMessages.textExplore)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.fetchNewsIfNeeded()
        }
        .onAppear {
            Task {
                await viewModel.updateSavedStatus()
            }
        }
        .refreshable {
            await viewModel.fetchNews()
        }
    }
}
