//
//  Coordinator.swift
//  F1 Stats
//
//  Created by Matthew Reddin on 08/03/2022.
//

import Foundation
import UIKit

@MainActor
protocol Coordinator {
    var navigationController: UINavigationController { get }
    var networkProvider: NetworkMediaProvider { get }
    var imageProvider: ImageService { get }
    func start()
    func selectPerson(id: Int)
}

extension Coordinator {
    func selectPerson(id: Int) {
        let vc = UIStoryboard(name: "PersonDetail", bundle: nil).instantiateViewController(identifier: "PersonDetail") { coder in
            PersonDetailViewController(viewModel: PersonDetailViewModel(personID: id, service: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider)), personCoordinator: PersonCoordinator(imageProvider: imageProvider, networkProvider: networkProvider, navigationController: navigationController), coder: coder)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}

extension Coordinator where Self == PersonCoordinator {
    func selectPerson(id: Int) {
        let vc = UIStoryboard(name: "PersonDetail", bundle: nil).instantiateViewController(identifier: "PersonDetail") { coder in
            PersonDetailViewController(viewModel: PersonDetailViewModel(personID: id, service: MediaService(mediaProvider: self.networkProvider, imageProvider: self.imageProvider)), personCoordinator: self, coder: coder)
        }
        navigationController.pushViewController(vc, animated: true)
    }
}
