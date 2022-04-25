//
//  FavouritesViewModel.swift
//  Top Media
//
//  Created by Matthew Reddin on 04/04/2022.
//

import SwiftUI
import CoreData

class FavouritesViewModel: ObservableObject {
    
    @Published var favourites: [FavouriteMedia] = []
    let databaseProvider = DatabaseProvider()
    let mediaService: MediaService
    var managedObjectSaveNotification: NSObjectProtocol?
    
    init(service: MediaService) {
        self.mediaService = service
        favourites = databaseProvider.fetchFavourites()
        managedObjectSaveNotification = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: PersistanceCoordinator.shared.container.viewContext, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            for case let (key as String, value) in notification.userInfo ?? [:] {
                switch key {
                case NSInsertedObjectsKey:
                    self.favourites.append(contentsOf: value as! Set<FavouriteMedia>)
                case NSDeletedObjectsKey:
                    self.favourites.removeAll(where: (value as! Set<FavouriteMedia>).contains(_:))
                default:
                    break
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(managedObjectSaveNotification as Any)
    }
}
