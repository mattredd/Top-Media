//
//  PersonCredit.swift
//  Top Media
//
//  Created by Matthew Reddin on 22/03/2022.
//

import Foundation

struct PersonCredit: Codable, Hashable {
    let id: Int?
    let name: String?
    let character: String?
    let profilePath: String?
    let job: String?
}

struct MediaCredits: Codable {
    let cast: [PersonCredit]?
    let crew: [PersonCredit]?
}
