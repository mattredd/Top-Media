//
//  MainCoordinator.swift
//  F1 Stats
//
//  Created by Matthew Reddin on 08/03/2022.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class HomeCoordinator: Coordinator {
    
    let imageProvider: ImageService
    let networkProvider: NetworkMediaProvider
    var navigationController: UINavigationController
    
    init(imageProvider: ImageService, networkProvider: NetworkMediaProvider, navigationController: UINavigationController) {
        self.imageProvider = imageProvider
        self.networkProvider = networkProvider
        self.navigationController = navigationController
    }

    func start() {
        let vc = MediaTrendsViewController(mediaService: MediaService(mediaProvider: networkProvider, imageProvider: imageProvider), imageService: imageProvider, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectMedia(id: Int, isFilm: Bool) {
        let vc = UIHostingController(rootView: MediaDetailView(mediaDetailVM: MediaDetailViewModel(mediaID: id, isFilm: isFilm, mediaService: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider), coordinator: self)))
        navigationController.pushViewController(vc, animated: true)
    }
}
