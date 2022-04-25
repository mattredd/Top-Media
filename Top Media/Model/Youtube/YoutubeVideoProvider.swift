//
//  YoutubeVideoProviderP.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import Foundation

protocol YoutubeProvider {
    func fetchYoutubeVideoMetadeta(ids: [String]) async throws -> [YoutubeVideo]
}
