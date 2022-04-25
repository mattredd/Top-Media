//
//  DatabaseProvider.swift
//  Books
//
//  Created by Matthew Reddin on 25/01/2022.
//

import Foundation

class DatabaseProvider {
    
    func fetchFavourites() -> [FavouriteMedia] {
        let moc = PersistanceCoordinator.shared.container.viewContext
        do {
            let fetchRequest = FavouriteMedia.fetchRequest()
            fetchRequest.sortDescriptors = [.init(keyPath: \FavouriteMedia.dateAdded, ascending: true)]
            return try moc.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
}
