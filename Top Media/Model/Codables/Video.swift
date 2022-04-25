//
//  Video.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let site: String
    let official: Bool
}
