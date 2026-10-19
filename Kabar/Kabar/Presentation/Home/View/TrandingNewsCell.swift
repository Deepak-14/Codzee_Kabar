//
//  TrandingNewsCell.swift
//  Kabar
//
//  Created by user on 23/08/26.
//

import SwiftUI

public struct TrandingNewsCell: View {
    public var imgUrl: String
    public var title: String
    public var newsDescription: String
    public var lineLimitDetail: Bool = false
    public var lineLimitTitle: Bool = false

    public init(
        imgUrl: String,
        title: String,
        newsDescription: String,
        lineLimitDetail: Bool = false,
        lineLimitTitle: Bool = false
    ) {
        self.imgUrl = imgUrl
        self.title = title
        self.newsDescription = newsDescription
        self.lineLimitDetail = lineLimitDetail
        self.lineLimitTitle = lineLimitTitle
    }

    public var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: imgUrl))
                .frame(minWidth: 100, maxWidth: .infinity, maxHeight: 180)
                .cornerRadius(8)
                .clipped()

            Text(title)
                .font(Font.system(size: 13))
                .fontWeight(.regular)
                .foregroundColor(Color.colorGrayPurple)
                .lineLimit(lineLimitTitle ? 1 : nil)
                .padding(.top, 8)

            Text(newsDescription)
                .font(Font.system(size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color.black)
                .lineLimit(lineLimitDetail ? 2 : nil)
                .padding(.top, 4)
                .padding(.bottom, 4)
        }
    }
}
