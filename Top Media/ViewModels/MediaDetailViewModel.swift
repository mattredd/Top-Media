//
//  MediaDetailViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 17/03/2022.
//

import SwiftUI

class MediaDetailViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var networkImage: UIImage?
    @Published var media: MediaDetail?
    @Published var credits: MediaCredits?
    let mediaID: Int
    let isFilm: Bool
    let mediaService: MediaService
    let coordinator: Coordinator
    
    init(mediaID: Int, isFilm: Bool, mediaService: MediaService, coordinator: Coordinator) {
        self.coordinator = coordinator
        self.mediaID = mediaID
        self.isFilm = isFilm
        self.mediaService = mediaService
    }
    
    @MainActor
    func fetchMediaDetail() async {
        media = try? await mediaService.fetchMediaDetails(id: mediaID, isFilm: isFilm)
        if let img = media?.backdropPath {
            image = try? await mediaService.fetchImage(posterPath: img, posterSize: .large)
        } else if let img = media?.posterPath {
            image = try? await mediaService.fetchImage(posterPath: img, posterSize: .large)
        }
        if let networkImagePath = media?.networks?.first?.logoPath {
            networkImage = try? await mediaService.fetchImage(posterPath: networkImagePath, posterSize: .small)
        }
        credits = (try? await mediaService.fetchCredits(mediaID: mediaID, isFilm: isFilm)) ?? nil
    }
    
    func favouriteChanged(oldValue: Bool?, newValue: Bool?) {
        guard let id = media?.id else { return }
        let moc = PersistanceCoordinator.shared.container.viewContext
        guard oldValue != nil else { return }
        if newValue! {
            let obj = FavouriteMedia(context: moc)
            obj.dateAdded = .now
            obj.id = Int64(id)
            obj.isFilm = isFilm
            obj.name = media?.title ?? media?.name
            obj.posterPath = media?.posterPath
        } else {
            let fetchRequest = FavouriteMedia.fetchRequest()
            let pred = NSPredicate(format: "id == %d", Int64(id))
            fetchRequest.predicate = pred
            if let result = try? moc.fetch(fetchRequest) {
                for i in result {
                    moc.delete(i)
                }
            }
        }
        try? moc.save()
    }
    
    func loadFavourite() -> Bool? {
        guard let id = media?.id else { return nil }
        let moc = PersistanceCoordinator.shared.container.viewContext
        let fetchRequest = FavouriteMedia.fetchRequest()
        let pred = NSPredicate(format: "id == %d", Int64(id))
        fetchRequest.predicate = pred
        return (try? moc.count(for: fetchRequest)) ?? 0 != 0
    }
}
