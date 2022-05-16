//
//  VideosViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import Foundation

@MainActor
class VideosViewModel<S: YoutubeProvider>: ObservableObject {
    
    @Published var youtubeVideos: [YoutubeVideo] = []
    let service: YoutubeService<S>
    let videos: [Video]?
    var errorMessage = ""
    
    init(service: YoutubeService<S>, videos: [Video]?) {
        self.service = service
        self.videos = videos
        Task {
            do {
                if let videos = videos {
                    let vids = try await service.fetchVideoMetadata(ids: Array(videos.lazy.filter({ $0.site == "YouTube"}).map(\.key)))
                    youtubeVideos = vids.sorted { videoA, videoB in
                        Int(videoA.statistics.viewCount)! > Int(videoB.statistics.viewCount)!
                    }
                    if vids.isEmpty {
                        errorMessage = "No videos are available"
                    }
                }
            }
            catch {
                errorMessage = "Unable to display videos"
            }
        }
    }
}
