//
//  MediaTrendsViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 10/03/2022.
//

import UIKit
import Combine

class MediaTrendsViewController: UIViewController, UICollectionViewDelegate {
    
    let collectionView: UICollectionView
    let mediaChooser: UISegmentedControl
    let dataSource: MediaTrendingDataSource
    let coordinator: HomeCoordinator
    var cancellables: Set<AnyCancellable> = []
    let errorMessageLabel = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(mediaService: MediaService, imageService: ImageService, coordinator: HomeCoordinator) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayouts.homeCollectionViewLayout)
        dataSource = MediaTrendingDataSource(collectionView: collectionView, mediaTrendsVM: TrendingMediaViewModel(mediaService: mediaService), imageService: imageService)
        mediaChooser = UISegmentedControl(items: ["", ""])
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
        mediaChooser.setAction(UIAction(title: "Films") { [unowned self] _ in
            Task {
                await self.dataSource.mediaTrendsVM.fetchTrendingMedia(films: true)
            }
        }, forSegmentAt: 0)
        mediaChooser.setAction(UIAction(title: "TV Shows") { [unowned self] _ in
            Task {
                await self.dataSource.mediaTrendsVM.fetchTrendingMedia(films: false)
            }
        }, forSegmentAt: 1)
        mediaChooser.selectedSegmentIndex = 0
        dataSource.mediaTrendsVM.$errorMessage.receive(on: RunLoop.main).sink { [weak self] message in
            if message.isEmpty {
                self?.errorMessageLabel.text = ""
                self?.errorMessageLabel.alpha = 0
            } else {
                self?.errorMessageLabel.text = message
                self?.errorMessageLabel.alpha = 1
            }
        }.store(in: &cancellables)
    }
    
    //MARK: ViewController Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addSubview(mediaChooser)
        view.addSubview(errorMessageLabel)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .secondaryLabel
        mediaChooser.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mediaChooser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mediaChooser.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: mediaChooser.bottomAnchor, multiplier: 1),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    //MARK: Collectionview Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id: Int?
        if indexPath.section == 0 || indexPath.section == 2 {
            if indexPath.section == 0 {
                id = dataSource.mediaTrendsVM.trendingMedia[0].id
            } else {
                id = dataSource.mediaTrendsVM.newReleasesMedia[0].id
            }
        } else {
            if indexPath.section == 1 {
                id = dataSource.mediaTrendsVM.trendingMedia[indexPath.item + 1].id
            } else {
                id = dataSource.mediaTrendsVM.newReleasesMedia[indexPath.item + 1].id
            }
        }
        if let id = id {
            coordinator.selectMedia(id: id, isFilm: mediaChooser.selectedSegmentIndex == 0)
        }
    }
    
}
