//
//  HomeView.swift
//  Kabar
//
//  Created by user on 11/08/26.
//

import SwiftUI

public struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @Binding var path: NavigationPath

    public init(
        path: Binding<NavigationPath>,
        viewModel: HomeViewModel? = nil
    ) {
        _path = path
        _viewModel = State(initialValue: viewModel ?? AppDIContainer.shared.makeHomeViewModel())
    }

    public var body: some View {
        @Bindable var vm = viewModel

        VStack {
            // Custom Search Bar
            CustomSearchBar(searchText: $vm.searchText)

            if vm.isLoading && vm.newsData.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                // News List
                List {
                    Section {
                        ForEach(vm.newsData.prefix(1)) { news in
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
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    } header: {
                        HeaderTitleView(
                            headername: AppMessages.textTranding,
                            seeAll: AppMessages.textSeeAll,
                            isSeeAllActive: true
                        )
                    }
                    .listStyle(.plain)

                    Section {
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(vm.filterHeaders()) { category in
                                        let name = category.title
                                        Button {
                                            vm.setNewsFilter(name)
                                        } label: {
                                            Text(name)
                                                .foregroundStyle(vm.selectedSource == name ? Color.white : .primary)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(vm.selectedSource == name ? Color.blue : Color.gray.opacity(0.15))
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.bottom, 10)

                            ForEach(vm.filteredNews) { news in
                                Button {
                                    if path.count > 0 {
                                        path.removeLast()
                                    }
                                    path.append(AppRoute.newsDetail(news))
                                } label: {
                                    NewsCell(
                                        imgUrl: news.urlToImage ?? "",
                                        title: news.title ?? "",
                                        newsDescription: news.description ?? ""
                                    )
                                }
                                .padding(.bottom, 10)
                                .buttonStyle(.plain)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        }
                    } header: {
                        HeaderTitleView(
                            headername: AppMessages.textTranding,
                            seeAll: AppMessages.textSeeAll,
                            isSeeAllActive: true
                        )
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchNewsIfNeeded()
        }
        .refreshable {
            await viewModel.fetchNews()
        }
    }
}
