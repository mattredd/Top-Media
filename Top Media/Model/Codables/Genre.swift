//
//  Genre.swift
//  Top Media
//
//  Created by Matthew Reddin on 25/04/2022.
//

import Foundation

struct Genre: Codable, Hashable {
    let id: Int?
    let name: String?
}

struct GenreResponse: Codable {
    let genres: [Genre]
}
