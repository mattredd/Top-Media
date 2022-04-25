//
//  SearchCoordinator.swift
//  Top Media
//
//  Created by Matthew Reddin on 19/03/2022.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class SearchCoordinator: Coordinator {
    
    let imageProvider: ImageService
    let networkProvider: NetworkMediaProvider
    var navigationController: UINavigationController
    
    init(imageProvider: ImageService, networkProvider: NetworkMediaProvider, navigationController: UINavigationController) {
        self.imageProvider = imageProvider
        self.networkProvider = networkProvider
        self.navigationController = navigationController
    }

    func start() {
        let vc = UIStoryboard(name: "MediaSearch", bundle: nil).instantiateViewController(identifier: MediaSearchViewController.identifier) { coder in
            MediaSearchViewController(coder: coder, viewModel: MediaSearchViewModel(service: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider)), coordinator: self)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func selectMedia(id: Int, isFilm: Bool) {
        let vc = UIHostingController(rootView: MediaDetailView(mediaDetailVM: MediaDetailViewModel(mediaID: id, isFilm: isFilm, mediaService: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider), coordinator: self)))
        navigationController.pushViewController(vc, animated: true)
    }
}
