//
//  StockProvider.swift
//  Stocks
//
//  Created by Matthew Reddin on 10/03/2022.
//

import Foundation

typealias MediaProvider = MediaGenresProvider & MediaPersonProvider & ImageProvider & SearchMediaProvider & MediaDetailsProvider & TopMediaProvider

protocol MediaGenresProvider {
    func findGenres(film: Bool) async throws -> [Genre]
}

protocol MediaPersonProvider {
    func fetchTrendingPeople() async throws -> [Person]
    func fetchPersonAppearanceMediaDetail(id: Int) async throws -> [MediaDetail]
    func fetchPersonDetails(id: Int) async throws -> PersonInformation
    func fetchCredits(mediaID: Int, isFilm: Bool) async throws -> MediaCredits
}

protocol ImageProvider {
    func fetchImagePath(filePath: String, size: ImageSize) async throws -> String
    func fetchImage(path: String, size: ImageSize) async throws -> Data?
}

protocol SearchMediaProvider {
    func findFilms(searchTerm: String) async throws -> [MediaDetail]
    func findTVShows(searchTerm: String) async throws -> [MediaDetail]
}

protocol MediaDetailsProvider {
    func fetchFilmDetails(id: Int) async throws -> MediaDetail
    func fetchTVDetails(id: Int) async throws -> MediaDetail
}

protocol TopMediaProvider {
    func fetchTrends(films: Bool) async throws -> [MediaDetail]
    func fetchNewReleases(films: Bool) async throws -> [MediaDetail]
}
