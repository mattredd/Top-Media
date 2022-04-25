//
//  PersonCoordinator.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class PersonCoordinator: Coordinator {
    
    let imageProvider: ImageService
    let networkProvider: NetworkMediaProvider
    var navigationController: UINavigationController
    
    init(imageProvider: ImageService, networkProvider: NetworkMediaProvider, navigationController: UINavigationController) {
        self.imageProvider = imageProvider
        self.networkProvider = networkProvider
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = PersonViewController(mediaProvider: networkProvider, imageService: imageProvider, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectCredit(id: Int, isFilm: Bool) {
        let vc = UIHostingController(rootView: MediaDetailView(mediaDetailVM: MediaDetailViewModel(mediaID: id, isFilm: isFilm, mediaService: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider), coordinator: self)))
        navigationController.pushViewController(vc, animated: true)
    }
    
}
