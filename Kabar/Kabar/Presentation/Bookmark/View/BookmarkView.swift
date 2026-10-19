//
//  BookmarkView.swift
//  Kabar
//
//  Created by user on 11/08/26.
//

import SwiftUI

public struct BookmarkView: View {
    @State private var viewModel: BookmarkViewModel
    @Binding var path: NavigationPath

    public init(
        path: Binding<NavigationPath>,
        viewModel: BookmarkViewModel? = nil
    ) {
        _path = path
        _viewModel = State(initialValue: viewModel ?? AppDIContainer.shared.makeBookmarkViewModel())
    }

    public var body: some View {
        @Bindable var vm = viewModel

        VStack {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search news", text: $vm.searchText)
                    .textFieldStyle(.plain)

                if !vm.searchText.isEmpty {
                    Button {
                        vm.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.vertical, 8)

            if vm.isLoading && vm.savedNews.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else if vm.filteredNews.isEmpty {
                Spacer()
                Text("No bookmarked news found.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
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
                        .buttonStyle(.plain)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let item = vm.filteredNews[index]
                            Task {
                                await vm.deleteBookmark(id: item.id)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle(AppMessages.textBookMark)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchAllBookmarks()
        }
        .onAppear {
            Task {
                await viewModel.fetchAllBookmarks()
            }
        }
    }
}
