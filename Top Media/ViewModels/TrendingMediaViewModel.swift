//
//  TrendingMediaViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 10/03/2022.
//

import SwiftUI

class TrendingMediaViewModel: ObservableObject {
    
    @Published var trendingMedia: [MediaDetail] = []
    @Published var newReleasesMedia: [MediaDetail] = []
    @Published var errorMessage = ""
    let mediaService: MediaService
    
    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }
    
    func fetchTrendingMedia(films: Bool) async {
        errorMessage = ""
        do {
            trendingMedia = try await mediaService.fetchMovieTrends(films: films)
            newReleasesMedia = try await mediaService.fetchNewReleases(films: films)
        }
        catch {
            if trendingMedia.isEmpty && newReleasesMedia.isEmpty {
                errorMessage = "Unable to display items due to any error."
            }
        }
    }
    
}
