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
        try await youtubeProvider.fetchYoutubeVideoMetadeta(ids: ids)
    }
}
