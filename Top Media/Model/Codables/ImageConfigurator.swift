//
//  ImageConfigurator.swift
//  Top Media
//
//  Created by Matthew Reddin on 11/03/2022.
//

import Foundation

struct ImageConfigurator: Codable {
    let baseUrl: String?
    let secureBaseUrl: String?
    let backdropSizes: [String]?
    let logoSizes: [String]?
    let posterSizes: [String]?
    let stillSizes: [String]?
}

struct ImageConfiguratorResponse: Codable {
    let images: ImageConfigurator
}

enum ImageSize: String {
    case xSmall, small, medium, large, original
}
