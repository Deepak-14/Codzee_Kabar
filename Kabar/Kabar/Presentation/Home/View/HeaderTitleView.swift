//
//  HeaderTitleView.swift
//  Kabar
//
//  Created by user on 23/08/26.
//

import SwiftUI

public struct HeaderTitleView: View {
    public var headername: String
    public var seeAll: String
    public var isSeeAllActive: Bool

    public init(headername: String, seeAll: String, isSeeAllActive: Bool) {
        self.headername = headername
        self.seeAll = seeAll
        self.isSeeAllActive = isSeeAllActive
    }

    public var body: some View {
        HStack {
            Text(headername)
                .font(Font.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
            Spacer()
            if isSeeAllActive {
                Text(seeAll)
                    .font(Font.system(size: 14))
                    .fontWeight(.regular)
                    .foregroundColor(Color.colorGrayPurple)
            }
        }
    }
}
