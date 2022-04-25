//
//  PersonDetail.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import Foundation

struct PersonInformation: Codable, Hashable {
    let name: String?
    let birthday: String?
    let placeOfBirth: String?
    let biography: String?
    let profilePath: String?
}
