//
//  YoutubeAPIResponse.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import Foundation

struct YoutubeAPIResponse: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id: String
    let snippet: YoutubeVideoSnippet
    let contentDetails: YoutubeVideoContentDetails
    var statistics: YoutubeVideoStatistics
}

struct YoutubeVideoSnippet: Codable {
    let publishedAt: Date
    let title: String
    let description: String
    let thumbnails: [String: YoutubeVideoThumbnail]
    let channelTitle: String
    
}

struct YoutubeVideoContentDetails: Codable {
    let duration: String
    let dimension: String
    let definition: String
    let caption: String
}

struct YoutubeVideoStatistics: Codable {
    let viewCount: String
    let likeCount: String?
    let favoriteCount: String
    let commentCount: String?
}

struct YoutubeVideoThumbnail: Codable {
    let url: URL
    let width: Int
    let height: Int
}

enum YoutubeVideoThumbnailOptions: String {
    case `default`, medium, high, standard, maxres
}
