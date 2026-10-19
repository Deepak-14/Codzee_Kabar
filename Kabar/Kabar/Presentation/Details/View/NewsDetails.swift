//
//  NewsDetails.swift
//  Kabar
//
//  Created by user on 23/08/26.
//

import SwiftUI

public struct NewsDetails: View {
    public var news: Article?
    @State private var viewModel: NewsDetailsViewModel

    public init(news: Article?, viewModel: NewsDetailsViewModel? = nil) {
        self.news = news
        let vm = viewModel ?? AppDIContainer.shared.makeNewsDetailsViewModel(article: news)
        _viewModel = State(initialValue: vm)
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                FollowingCell(
                    imgUrl: news?.urlToImage ?? "",
                    title: news?.title ?? "",
                    newsDescription: news?.description ?? "",
                    isFollowing: false,
                    width: 50
                )
                .padding(.horizontal, 10)

                TrandingNewsCell(
                    imgUrl: news?.urlToImage ?? "",
                    title: news?.title ?? "",
                    newsDescription: news?.description ?? "",
                    lineLimitDetail: false,
                    lineLimitTitle: false
                )
                .padding(.horizontal, 10)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    // Like action
                } label: {
                    HStack {
                        Image("icon_like")
                        Text("23k")
                    }
                }
                .padding()

                Button {
                    // Comment action
                } label: {
                    HStack {
                        Image("icon_comment")
                        Text("23k")
                    }
                }
                .padding()

                Spacer()

                Button {
                    Task {
                        await viewModel.toggleBookmark()
                    }
                } label: {
                    Image(viewModel.isNewsSaved ? "icon_bookmark_select" : "icon_bookmark_unselect")
                }
                .padding()
            }
            .background(.background)
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.checkBookmarkStatus()
        }
    }
}
