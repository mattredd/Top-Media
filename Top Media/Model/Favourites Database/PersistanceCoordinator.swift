//
//  PersistanceCoordinator.swift
//  Books
//
//  Created by Matthew Reddin on 25/01/2022.
//

import Foundation
import CoreData

class PersistanceCoordinator {
    
    static let shared = PersistanceCoordinator()
    let container: NSPersistentContainer
    
    init() {
       container = NSPersistentContainer(name: "Favourites")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }
}
