//
//  FollowingCell.swift
//  Kabar
//
//  Created by user on 23/08/26.
//

import SwiftUI

public struct FollowingCell: View {
    public var imgUrl: String
    public var title: String
    public var newsDescription: String
    public var isFollowing: Bool
    public var width: Float = 50

    public init(
        imgUrl: String,
        title: String,
        newsDescription: String,
        isFollowing: Bool,
        width: Float = 50
    ) {
        self.imgUrl = imgUrl
        self.title = title
        self.newsDescription = newsDescription
        self.isFollowing = isFollowing
        self.width = width
    }

    public var body: some View {
        HStack {
            AsyncImage(url: URL(string: imgUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image("icon_news_fallback")
                        .resizable()
                        .scaledToFill()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: CGFloat(width), maxHeight: CGFloat(width))
            .clipShape(.circle)
            .clipped()

            VStack(alignment: .leading) {
                Text(title)
                    .font(Font.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundColor(Color.colorGrayPurple)
                    .lineLimit(1)
                    .padding(.top, 8)

                Text(newsDescription)
                    .font(Font.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(Color.black)
                    .lineLimit(2)
                    .padding(.bottom, 4)
            }
            .padding(.trailing, 10)

            Spacer()

            Button {
                // Future follow action
            } label: {
                Text(isFollowing ? AppMessages.textFollowing : AppMessages.textFollow)
                    .foregroundColor(isFollowing ? Color.white : Color.black)
            }
            .border(isFollowing ? Color.blue : Color.white, width: 1)
            .buttonStyle(.bordered)
            .cornerRadius(8)
            .background(isFollowing ? Color.blue : Color.white)
            .clipShape(.capsule)
        }
    }
}
