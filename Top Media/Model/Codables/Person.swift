//
//  Person.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import Foundation

struct Person: Codable, Hashable {
    let id: Int
    let name: String
    let profilePath: String
    let adult: Bool
}

struct PersonImage: Codable {
    let filePath: String
}

struct PersonRequestResponse: Codable {
    let page: Int
    let results: [Person]
    let totalPages: Int
    let totalResults: Int
}
