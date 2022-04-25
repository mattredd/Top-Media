//
//  MediaService.swift
//  Top Media
//
//  Created by Matthew Reddin on 10/03/2022.
//

import Foundation
import UIKit

class MediaService {
    
    init(mediaProvider: MediaProvider, imageProvider: ImageService) {
        self.mediaProvider = mediaProvider
        self.imageService = imageProvider
    }
    
    let mediaProvider: MediaProvider
    let imageService: ImageService
    var filmGenres: [Int: String]? = nil
    var tvGenres: [Int: String]? = nil
    
    func fetchMovieTrends(films: Bool) async throws -> [MediaDetail] {
        try await mediaProvider.fetchTrends(films: films)
    }
    
    func fetchNewReleases(films: Bool) async throws -> [MediaDetail] {
        try await mediaProvider.fetchNewReleases(films: films)
    }
    
    func fetchMediaDetails(id: Int, isFilm: Bool) async throws -> MediaDetail {
        if isFilm {
            return try await mediaProvider.fetchFilmDetails(id: id)
        } else {
            return try await mediaProvider.fetchTVDetails(id: id)
        }
    }
    
    func fetchImage(posterPath: String, posterSize: ImageSize) async throws -> UIImage? {
        try await imageService.fetchImage(path: posterPath, size: posterSize)
    }
    
    func searchMedia(searchTerm: String?, mediaType: MediaSearchType) async throws -> [[MediaDetail]] {
        guard let searchTerm = searchTerm, let encodedSearchTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        switch mediaType {
        case .all:
            var result: [[MediaDetail]] = []
            result.append(try await mediaProvider.findFilms(searchTerm: encodedSearchTerm).filter({ ($0.originalLanguage ?? "") == "en" }))
            result.append(try await mediaProvider.findTVShows(searchTerm: encodedSearchTerm).filter({ ($0.originalLanguage ?? "") == "en" }))
            return result
        case .tv:
            return try await [[], mediaProvider.findTVShows(searchTerm: encodedSearchTerm).filter({ ($0.originalLanguage ?? "") == "en" })]
        case .films:
            return try await [mediaProvider.findFilms(searchTerm: encodedSearchTerm).filter({ ($0.originalLanguage ?? "") == "en" }), []]
        }
    }
    
    func findGenres(film: Bool) async throws -> [Int: String] {
        if film {
            if let filmGenres = filmGenres {
                return filmGenres
            } else {
                filmGenres = [:]
                let genres = try await mediaProvider.findGenres(film: film)
                for genre in genres where genre.id != nil {
                    filmGenres![genre.id!] = genre.name
                }
                return filmGenres!
            }
        } else {
            if let tvGenres = tvGenres {
                return tvGenres
            } else {
                tvGenres = [:]
                let genres = try await mediaProvider.findGenres(film: film)
                for genre in genres where genre.id != nil {
                    tvGenres![genre.id!] = genre.name
                }
                return tvGenres!
            }
        }
    }
    
    func fetchTrendingPeople() async throws -> [Person] {
        try await mediaProvider.fetchTrendingPeople()
    }
    
    func fetchPersonDetails(id: Int) async throws -> PersonInformation {
        try await mediaProvider.fetchPersonDetails(id: id)
    }
    
    func fetchPersonCredits(id: Int) async throws -> [MediaDetail] {
        try await mediaProvider.fetchPersonAppearanceMediaDetail(id: id)
    }
    
    func fetchCredits(mediaID: Int, isFilm: Bool) async throws -> MediaCredits {
        try await mediaProvider.fetchCredits(mediaID: mediaID, isFilm: isFilm)
    }
    
    func fetchImagePath(filePath: String, size: ImageSize) async throws -> String {
        try await mediaProvider.fetchImagePath(filePath: filePath, size: size)
    }
}
