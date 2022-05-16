//
//  MediaSearchViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 17/03/2022.
//

import SwiftUI
import Combine

@MainActor
class MediaSearchViewModel: ObservableObject {
    
    @Published var media: [[MediaDetail]] = []
    @Published var searchParameters: (searchTerm: String?, searchType: MediaSearchType) = (nil, .all)
    @Published var message = ""
    let mediaService: MediaService
    var cancellables: Set<AnyCancellable> = []
    var searchTask: Task<Void, Never>?
    
    init(service: MediaService) {
        self.mediaService = service
        $searchParameters.throttle(for: 0.5, scheduler: RunLoop.main, latest: true).sink(receiveValue: { [weak self] searchTerm, searchType in
            guard let self = self, let searchTerm = searchTerm, !searchTerm.isEmpty else { self?.media = []; return }
            self.searchTask?.cancel()
            self.searchTask = Task {
                await self.searchMedia(searchTerm: searchTerm, searchType: searchType)
            }
        }).store(in: &cancellables)
    }
    
    func searchMedia(searchTerm: String?, searchType: MediaSearchType) async {
        message = ""
        guard let searchTerm = searchTerm, !searchTerm.isEmpty else { return }
        do {
            let newMedia = try await mediaService.searchMedia(searchTerm: searchTerm, mediaType: searchType)
            guard !Task.isCancelled else { return }
            media = newMedia
            if media[0].isEmpty && media[1].isEmpty {
                message = "Unable to find media for your search query"
            }
        }
        catch {
            message = "There was an error finding results"
        }
    }
    
    func fetchGenreLabels(for ids: [Int], isFilm: Bool) async -> [String] {
        var genre: [String] = []
        let foundGenres = (try? await mediaService.findGenres(film: isFilm)) ?? [:]
        for id in ids {
            if let name = foundGenres[id] {
                genre.append(name)
            }
        }
        return genre
    }
    
}
