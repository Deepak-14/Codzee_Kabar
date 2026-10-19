//
//  NewsCell.swift
//  Kabar
//
//  Created by user on 23/08/26.
//

import SwiftUI

public struct NewsCell: View {
    public var imgUrl: String
    public var title: String
    public var newsDescription: String

    public init(imgUrl: String, title: String, newsDescription: String) {
        self.imgUrl = imgUrl
        self.title = title
        self.newsDescription = newsDescription
    }

    public var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: imgUrl))
                .frame(minWidth: 96, maxWidth: 96, maxHeight: 96)
                .cornerRadius(8)
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
        }
    }
}
