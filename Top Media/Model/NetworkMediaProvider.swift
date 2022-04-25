//
//  NetworkStockProvider.swift
//  Stocks
//
//  Created by Matthew Reddin on 10/03/2022.
//

import Foundation

class NetworkMediaProvider {
    
    let baseURL = "https://api.themoviedb.org/3/"
    var configurator: ImageConfigurator!
    let jsonDecoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.dateDecodingStrategy = .iso8601
        $0.dateDecodingStrategy = .custom { decoder in
            do {
                let unkeyedContainer = try decoder.singleValueContainer()
                let stringDate = try unkeyedContainer.decode(String.self)
                return (try? Date(stringDate, strategy: .iso8601.year().month().day())) ?? .now
            }
            catch {
                throw APIError.invalidReturnFormat
            }
        }
        return $0
    }(JSONDecoder())
    
    func fetchData<T: Decodable>(with request: URLRequest, decoding: T.Type) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw APIError.invalidResponse(statusCode: (response as! HTTPURLResponse).statusCode)
            }
            return try jsonDecoder.decode(decoding, from: data)
        }
        catch {
            if error is DecodingError {
                throw APIError.invalidReturnFormat
            } else if error is APIError {
                print("What")
                throw error
            } else {
                throw APIError.networkError
            }
        }
    }
}

extension NetworkMediaProvider: MediaPersonProvider {
    
    func fetchCredits(mediaID: Int, isFilm: Bool) async throws -> MediaCredits {
        guard let url = URL(string: baseURL + "\(isFilm ? "movie" : "tv")/\(mediaID)/credits?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: MediaCredits.self)
    }
    
    
    func fetchPersonAppearanceMediaDetail(id: Int) async throws -> [MediaDetail] {
        guard let url = URL(string: baseURL + "person/\(id)/combined_credits?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: PersonAppearanceDetailResponse.self).cast
    }
    
    func fetchPersonDetails(id: Int) async throws -> PersonInformation {
        guard let url = URL(string: baseURL + "person/\(id)?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: PersonInformation.self)
    }
    
    
    func fetchTrendingPeople() async throws -> [Person] {
        guard let url = URL(string: baseURL + "person/popular?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: PersonRequestResponse.self).results.filter({ !$0.adult })
    }
}

extension NetworkMediaProvider: MediaGenresProvider {
    
    func findGenres(film: Bool) async throws -> [Genre] {
        guard let url = URL(string: baseURL + "genre/\(film ? "movie" : "tv")/list?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: GenreResponse.self).genres
    }
}
    
extension NetworkMediaProvider: MediaDetailsProvider {
    
    func fetchFilmDetails(id: Int) async throws -> MediaDetail {
        guard let url = URL(string: baseURL + "movie/\(id)?api_key=\(AppConstants.tvdmAPIKey)&append_to_response=videos") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: MediaDetail.self)
    }
    
    func fetchTVDetails(id: Int) async throws -> MediaDetail {
        guard let url = URL(string: baseURL + "tv/\(id)?api_key=\(AppConstants.tvdmAPIKey)&append_to_response=videos") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: MediaDetail.self)
    }
}

extension NetworkMediaProvider: SearchMediaProvider {
    
    func findFilms(searchTerm: String) async throws -> [MediaDetail] {
        guard let url = URL(string: baseURL + "search/movie?api_key=\(AppConstants.tvdmAPIKey)&query=\(searchTerm)&include_adult=false") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: MediaRequestResponse.self).results
    }
    
    func findTVShows(searchTerm: String) async throws -> [MediaDetail] {
        guard let url = URL(string: baseURL + "search/tv?api_key=\(AppConstants.tvdmAPIKey)&query=\(searchTerm)&include_adult=false") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: MediaRequestResponse.self).results
    }
}
    
extension NetworkMediaProvider: TopMediaProvider {
    
    func fetchTrends(films: Bool) async throws -> [MediaDetail] {
        guard let url = URL(string: baseURL + "trending/\(films ? "movie" : "tv")/day?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        let trendingResponse = try await fetchData(with: URLRequest(url: url), decoding: MediaRequestResponse.self)
        return trendingResponse.results.map {
            var trend = $0
            trend.typeRequest = .trending
            return trend
        }
    }
    
    func fetchNewReleases(films: Bool) async throws -> [MediaDetail] {
        guard let url = URL(string: baseURL + "\(films ? "movie/upcoming" : "tv/on_the_air")?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        let newReleasesResponse = try await fetchData(with: URLRequest(url: url), decoding: MediaRequestResponse.self)
        return newReleasesResponse.results.map {
            var release = $0
            release.typeRequest = .newRelease
            return release
        }
    }
}

extension NetworkMediaProvider: ImageProvider {
    
    func fetchImagePath(filePath: String, size: ImageSize) async throws -> String {
        if configurator == nil {
            configurator = try await fetchImageConfigurator()
        }
        guard let baseURL = configurator.secureBaseUrl, let posterSizes = configurator.posterSizes, posterSizes.count != 0 else {
            throw APIError.invalidReturnFormat
        }
        let imageSize: String
        switch size {
        case .xSmall:
            imageSize = posterSizes[0]
        case .small:
            imageSize = posterSizes[posterSizes.count >= 3 ? 2 : posterSizes.count - 1]
        case .medium:
            imageSize = posterSizes[posterSizes.count / 2]
        case .large:
            imageSize = posterSizes[max(0, posterSizes.count - 2)]
        case .original:
            imageSize = posterSizes[posterSizes.count - 1]
        }
        return "\(baseURL)/\(imageSize)\(filePath)"
    }
    
    func fetchImage(path: String, size: ImageSize) async throws -> Data? {
        let stringURL = try await fetchImagePath(filePath: path, size: size)
        guard let url = URL(string: stringURL) else {
            throw APIError.invalidURL
        }
        do {
            return try await URLSession.shared.data(for: URLRequest(url: url)).0
        }
        catch {
            throw APIError.networkError
        }
    }
    
    private func fetchImageConfigurator() async throws -> ImageConfigurator {
        guard let url = URL(string: "https://api.themoviedb.org/3/configuration?api_key=\(AppConstants.tvdmAPIKey)") else {
            throw APIError.invalidURL
        }
        return try await fetchData(with: URLRequest(url: url), decoding: ImageConfiguratorResponse.self).images
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case invalidReturnFormat
    case networkError
}
