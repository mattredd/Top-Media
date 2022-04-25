//
//  YoutubeVideoProvider.swift
//  Top Media
//
//  Created by Matthew Reddin on 07/04/2022.
//

import Foundation

class NetworkYoutubeProvider: YoutubeProvider  {
    
    func fetchYoutubeVideoMetadeta(ids: [String]) async throws -> [YoutubeVideo] {
        let urlString = "https://www.googleapis.com/youtube/v3/videos?id=\(ids.joined(separator: ","))&key=\(AppConstants.youtubeAPiKey)&part=snippet,contentDetails,statistics"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { throw APIError.invalidURL }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw APIError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 400)}
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            return try jsonDecoder.decode(YoutubeAPIResponse.self, from: data).items
        }
        catch let error as APIError {
            throw error
        }
        catch let error as DecodingError{
            throw error
        }
        catch {
            throw APIError.networkError
        }
    }
}
