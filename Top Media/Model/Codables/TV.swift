//
//  Tv.swift
//  Top Media
//
//  Created by Matthew Reddin on 25/04/2022.
//

import Foundation

struct TVNetwork: Codable {
    let id: Int?
    let name: String?
    let logoPath: String?
}

struct TVSeason: Codable {
    let airDate: String?
    let id: Int?
    let episodeCount: Int?
    let seasonNumber: Int?
    let overview: String?
    let posterPath: String?
    let name: String?
}
