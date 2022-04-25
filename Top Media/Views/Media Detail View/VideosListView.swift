//
//  VideosListView.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import SwiftUI

struct VideosListView<S: YoutubeProvider>: View {
    
    @StateObject var viewModel: VideosViewModel<S>
    @Environment(\.openURL) var openURL
    
    var body: some View {
        if !(viewModel.videos ?? []).isEmpty {
            List {
                Section {
                    ForEach(viewModel.youtubeVideos, id: \.id) { video in
                        VideoListCellView(youtubeVideo: video)
                            .onTapGesture {
                                if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                                    openURL(url)
                                }
                            }
                    }
                } header: {
                    VStack(alignment: .leading) {
                        Text("Videos")
                            .font(.title.weight(.bold))
                            .foregroundColor(.primary)
                        Text("Video will open in your web browser")
                            .font(.caption2)
                    }
                    .textCase(.none)
                }
            }
        }
        Text(viewModel.errorMessage)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
}
