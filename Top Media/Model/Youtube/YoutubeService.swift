//
//  YoutubeService.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import Foundation

class YoutubeService<P: YoutubeProvider> {
    
    let youtubeProvider: P
    
    init(youtubeProvider: P) {
        self.youtubeProvider = youtubeProvider
    }
    
    func fetchVideoMetadata(ids: [String]) async throws -> [YoutubeVideo] {
        if ids.count <= 50 {
            return try await youtubeProvider.fetchYoutubeVideoMetadeta(ids: ids)
        } else {
            // As the API can only accept a max of 50 ids, we will need to break down the ids array and have separate API calls for each.
            var idsSplit: [[String]] = []
            let maxResults = 50
            for i in 0..<(ids.count / maxResults) {
                let startingIndex = i * maxResults
                let endIndex = startingIndex + maxResults
                let arr = Array(ids[startingIndex..<endIndex])
                idsSplit.append(contentsOf: [arr])
            }
            if ids.count % maxResults != 0 {
                let arr = Array(ids.suffix(ids.count % maxResults))
                idsSplit.append(contentsOf: [arr])
            }
            return try await withThrowingTaskGroup(of: [YoutubeVideo].self) { group in
                for i in idsSplit {
                    group.addTask {
                        return try await self.youtubeProvider.fetchYoutubeVideoMetadeta(ids: i)
                    }
                }
                var videos: [YoutubeVideo] = []
                for try await vid in group {
                    videos.append(contentsOf: vid)
                }
                return videos
            }
        }
    }
}
