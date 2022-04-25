//
//  CollectionViewLayouts.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import UIKit

struct CollectionViewLayouts {
    
    static var homeCollectionViewLayout: UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let topSection = sectionIndex == 0 || sectionIndex == 2
            let supplemantaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
            let supplemantaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplemantaryItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            let collectionItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(topSection ? 1.0 : 1.5), heightDimension: .estimated(topSection ? 175 : 150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: collectionItem, count: topSection ? 1 : 2)
            group.interItemSpacing = .fixed(UIConstants.systemSpacing)
            group.edgeSpacing = .init(leading: .none, top: .none, trailing: topSection ? .none : .fixed(8), bottom: .none)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = topSection ? .none : .continuous
            section.boundarySupplementaryItems = sectionIndex == 0 || sectionIndex == 2 ? [supplemantaryItem] : []
            section.contentInsets = .init(top: 0, leading: 8, bottom: UIConstants.systemSpacing * 2, trailing: UIConstants.systemSpacing)
            return section
        }
    }
    
    static var personCollectionViewLayout: UICollectionViewCompositionalLayout {
        let supplemantaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let supplemantaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplemantaryItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(UIConstants.systemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = UIConstants.systemSpacing
        section.boundarySupplementaryItems = [supplemantaryItem]
        section.contentInsets = .init(top: 0, leading: UIConstants.systemSpacing, bottom: 0, trailing: UIConstants.systemSpacing)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
