//
//  MovieDetail.swift
//  Top Media
//
//  Created by Matthew Reddin on 14/03/2022.
//

import Foundation

struct MediaDetail: Codable, Hashable {
    // Have to implement our own ID as using the ID from the API is causing collisions. Can ignore the warning as we have no need for it to be decoded.
    let uniqueID = UUID()
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let genreIds: [Int]?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: Date?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let videos: VideoResponse?
    let voteAverage: Double?
    let voteCount: Int?
    let seasons: [TVSeason]?
    let networks: [TVNetwork]?
    let name: String?
    let firstAirDate: String?
    var typeRequest: MediaTypeRequest?
    let mediaType: String?
    
    var isFilm: Bool? {
        if let mediaType = mediaType {
            return mediaType != "tv"
        }
        return nil
    }
    
    static func == (lhs: MediaDetail, rhs: MediaDetail) -> Bool {
        lhs.uniqueID == rhs.uniqueID && lhs.typeRequest == rhs.typeRequest
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
}

struct MediaRequestResponse: Codable {
    let page: Int
    let results: [MediaDetail]
    let totalPages: Int
    let totalResults: Int
}
