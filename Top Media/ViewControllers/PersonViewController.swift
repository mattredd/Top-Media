//
//  PersonViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import UIKit
import Combine

class PersonViewController: UIViewController, UICollectionViewDelegate {
    
    let collectionView: UICollectionView
    let dataSource: PersonDataSource
    let viewModel: PersonViewModel
    let coordinator: PersonCoordinator
    let messageLabel = UILabel()
    var cancellables: Set<AnyCancellable> = []
    
    init(mediaProvider: MediaProvider, imageService: ImageService, coordinator: PersonCoordinator) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayouts.personCollectionViewLayout)
        self.viewModel = PersonViewModel(service: MediaService(mediaProvider: mediaProvider, imageProvider: imageService))
        self.dataSource = PersonDataSource(collectionView: collectionView, viewModel: viewModel)
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.collectionView.delegate = self
        Task {
            await viewModel.fetchPeople()
        }
        viewModel.$message.sink { [weak self] message in
            if message.isEmpty {
                self?.messageLabel.alpha = 0
            } else {
                self?.messageLabel.alpha = 1
                self?.messageLabel.text = message
            }
        }.store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewController Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(collectionView.constraintsForAnchoringTo(boundsOf: view))
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        messageLabel.textColor = .secondaryLabel
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: Tableview Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.selectPerson(id: viewModel.people[indexPath.item].id)
    }

}
