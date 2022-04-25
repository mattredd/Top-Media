//
//  MediaSearchDataSource.swift
//  Top Media
//
//  Created by Matthew Reddin on 17/03/2022.
//

import UIKit
import Combine

@MainActor
class MediaSearchDataSource: NSObject, UITableViewDelegate {
    
    let diffableDataSource: SearchMediaDiffableDataSource
    let viewModel: MediaSearchViewModel
    var cancellables: Set<AnyCancellable> = []
    
    init(tableView: UITableView, viewModel: MediaSearchViewModel) {
        self.viewModel = viewModel
        diffableDataSource = SearchMediaDiffableDataSource(tableView: tableView) { tableView, indexPath, media in
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaSearchCell.identifier, for: indexPath) as! MediaSearchCell
            cell.asyncImage.imageService = viewModel.mediaService.imageService
            cell.asyncImage.imagePath = media.posterPath
            cell.titleLabel.text = media.originalTitle ?? media.originalName
            if let releaseDate = media.releaseDate?.formatted(date: .numeric, time: .omitted) {
                cell.extraInformationLabel.text = "Released: \(releaseDate)"
            } else if let firstAirDate = media.firstAirDate {
                cell.extraInformationLabel.text = "First Air Date: \(firstAirDate)"
            }
            return cell
        }
        diffableDataSource.defaultRowAnimation = .fade
        super.init()
        self.viewModel.$media.sink(receiveValue: { self.updateTableView(media: $0) }).store(in: &cancellables)
    }
    
    func updateTableView(media: [[MediaDetail]]) {
        guard !media.isEmpty else { diffableDataSource.apply(NSDiffableDataSourceSnapshot<Int, MediaDetail>()); return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, MediaDetail>()
        snapshot.appendSections([0])
        snapshot.appendItems(media[0], toSection: 0)
        snapshot.appendSections([1])
        snapshot.appendItems(media[1], toSection: 1)
        diffableDataSource.apply(snapshot)
    }
}

class SearchMediaDiffableDataSource: UITableViewDiffableDataSource<Int, MediaDetail> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard tableView.numberOfSections == 2 else { return nil }
        return section == 0 ? "Films" : "TV Shows"
    }
    
}
