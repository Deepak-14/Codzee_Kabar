//
//  Loaf.swift
//  Kabar
//
//  Created by user on 27/08/26.
//

import SwiftUI


struct CachedAsyncImage: View {

    let url: URL?

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {

        Group {

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()

            } else if isLoading {
                ProgressView()

            } else {
                Image("icon_news_fallback")
                    .resizable()
                    .scaledToFill()
            }
        }
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {

        guard let url else {
            return
        }

        // 1. Check cache
        if let cachedImage = ImageCache.shared.image(for: url) {
            image = cachedImage
            return
        }

        isLoading = true

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let downloadedImage = UIImage(data: data) else {
                return
            }

            // 2. Save to cache
            ImageCache.shared.insert(downloadedImage, for: url)

            // 3. Update UI
            image = downloadedImage

        } catch {

            print("Image loading failed:", error)
        }

        isLoading = false
    }
}
