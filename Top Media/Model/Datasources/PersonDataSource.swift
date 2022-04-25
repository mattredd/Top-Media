//
//  PersonDataSource.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import UIKit
import Combine

@MainActor
class PersonDataSource {
    
    let collectionView: UICollectionView
    let diffableDataSource: UICollectionViewDiffableDataSource<Int, Person>
    let viewModel: PersonViewModel
    var cancellables: Set<AnyCancellable> = []
    
    init(collectionView: UICollectionView, viewModel: PersonViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        let cellRegistration = UICollectionView.CellRegistration<PersonCell, Person> { cell, indexPath, itemIdentifier in
            cell.contentConfiguration = PersonContentConfiguration(person: itemIdentifier, imageService: viewModel.mediaService.imageService)
        }
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, person in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: person)
        })
        let collectionSupplementaryView = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            supplementaryView.headerLabel.text = "Trending People"
        }
        diffableDataSource.supplementaryViewProvider = { collection, elementKind, IndexPath in
            collection.dequeueConfiguredReusableSupplementary(using: collectionSupplementaryView, for: IndexPath)
        }
        viewModel.$people.sink(receiveValue: {
            self.applyChanges(people: $0)
        }).store(in: &cancellables)
    }
    
    func applyChanges(people: [Person]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Person>()
        snapshot.appendSections([0])
        snapshot.appendItems(people, toSection: 0)
        diffableDataSource.apply(snapshot)
    }
    
}
