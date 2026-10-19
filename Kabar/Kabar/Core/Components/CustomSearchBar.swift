//
//  CustomSearchBar.swift
//  Kabar
//
//  Created by user on 28/08/26.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        // Fixed Top App Icon
        HStack{
            Image("icon_app_logo")
            Spacer()
            Button {
                
            } label: {
                Image("icon_notification")
            }
        }
        .padding(.horizontal,24)
        
        // Fixed search bar
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search news", text: $searchText)
                .textFieldStyle(.plain)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
