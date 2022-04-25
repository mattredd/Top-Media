//
//  FavouriteDatasource.swift
//  Top Media
//
//  Created by Matthew Reddin on 04/04/2022.
//

import UIKit
import Combine

class FavouriteDatasource {
    
    let tableView: UITableView
    let dataSource: UITableViewDiffableDataSource<Int, FavouriteMedia>
    var cancellables: Set<AnyCancellable> = []
    let viewModel: FavouritesViewModel
    
    init(tableView: UITableView, viewModel: FavouritesViewModel) {
        self.tableView = tableView
        self.dataSource = UITableViewDiffableDataSource<Int, FavouriteMedia>(tableView: tableView) { tableView, indexPath, media in
            let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier) as! FavouriteTableViewCell
            if cell.asyncImage.imageService == nil {
                cell.asyncImage.imageService = viewModel.mediaService.imageService
            }
            cell.asyncImage?.imagePath = media.posterPath
            cell.asyncImage.contentMode = .scaleAspectFill
            cell.nameLabel.text = media.name
            return cell
        }
        self.viewModel = viewModel
        viewModel.$favourites.sink { [weak self] media in
            self?.updateTableView(media: media)
        }.store(in: &cancellables)
    }
    
    func updateTableView(media: [FavouriteMedia]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FavouriteMedia>()
        snapshot.appendSections([0])
        snapshot.appendItems(media, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
