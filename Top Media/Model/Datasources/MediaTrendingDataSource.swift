//
//  DriversDataSource.swift
//  F1 Stats
//
//  Created by Matthew Reddin on 07/03/2022.
//

import UIKit
import Combine

class MediaTrendingDataSource {
    
    let collectionView: UICollectionView
    let mediaTrendsVM: TrendingMediaViewModel
    let diffableDataSource: UICollectionViewDiffableDataSource<CollectionSection, MediaDetail>
    var cancellables: Set<AnyCancellable> = []
    let imageService: ImageService
    
    init(collectionView: UICollectionView, mediaTrendsVM: TrendingMediaViewModel, imageService: ImageService) {
        self.collectionView = collectionView
        self.mediaTrendsVM = mediaTrendsVM
        self.imageService = imageService
        Task {
            await mediaTrendsVM.fetchTrendingMedia(films: true)
        }
        let cellRegistration = UICollectionView.CellRegistration<MediaCollectionViewCell, MediaDetail> { cell, indexPath, itemIdentifier in
            let config = MediaTrendItemConfiguration(mediaTrend: itemIdentifier, large: indexPath.section == 0 || indexPath.section == 2, imageService: imageService, indexPosition: (indexPath.section % 2) + indexPath.row + 1)
            cell.contentConfiguration = config
        }
        diffableDataSource = UICollectionViewDiffableDataSource<CollectionSection, MediaDetail>(collectionView: collectionView) { collectionView, indexPath, media in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: media)
        }
        let collectionSupplView = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.headerLabel.text = indexPath.section == 0 ? "Trending" : "New Releases"
        }
        diffableDataSource.supplementaryViewProvider = { collection, elementKind, IndexPath in
            collection.dequeueConfiguredReusableSupplementary(using: collectionSupplView, for: IndexPath)
        }
        mediaTrendsVM.$trendingMedia.combineLatest(mediaTrendsVM.$newReleasesMedia).sink(receiveValue: { self.updateCollectionView(trendingMedia: $0, newReleasesMedia: $1)}).store(in: &cancellables)
    }
    
    func updateCollectionView(trendingMedia: [MediaDetail], newReleasesMedia: [MediaDetail]) {
        var snapshop = NSDiffableDataSourceSnapshot<CollectionSection, MediaDetail>()
        if !trendingMedia.isEmpty {
            snapshop.appendSections([.trendingTop, .trendingMain])
            snapshop.appendItems([trendingMedia[0]], toSection: .trendingTop)
            snapshop.appendItems(Array(trendingMedia[1...]), toSection: .trendingMain)
        }
        if !newReleasesMedia.isEmpty {
            snapshop.appendSections([.newReleasesTop, .newReleasesMain])
            snapshop.appendItems([newReleasesMedia[0]], toSection: .newReleasesTop)
            snapshop.appendItems(Array(newReleasesMedia[1...]), toSection: .newReleasesMain)
        }
        DispatchQueue.main.async {
            self.diffableDataSource.apply(snapshop)
        }
    }
}

enum CollectionSection: CaseIterable {
    case trendingTop, trendingMain, newReleasesTop, newReleasesMain
}
