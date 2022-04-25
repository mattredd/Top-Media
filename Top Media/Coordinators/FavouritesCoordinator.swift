//
//  FavouritesCoordinator.swift
//  Top Media
//
//  Created by Matthew Reddin on 04/04/2022.
//

import UIKit
import SwiftUI

class FavouritesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var networkProvider: NetworkMediaProvider
    var imageProvider: ImageService
    
    init(imageProvider: ImageService, networkProvider: NetworkMediaProvider, navigationController: UINavigationController) {
        self.imageProvider = imageProvider
        self.networkProvider = networkProvider
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FavouritesViewController(coordinator: self, favouriteViewModel: FavouritesViewModel(service: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider)))
        vc.title = "Favourites"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectMedia(favouriteMedia: FavouriteMedia) {
        let vm = MediaDetailViewModel(mediaID: Int(favouriteMedia.id), isFilm: favouriteMedia.isFilm, mediaService: MediaService(mediaProvider: networkProvider, imageProvider: imageProvider), coordinator: self)
        let vc = UIHostingController(rootView: MediaDetailView(mediaDetailVM: vm))
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
