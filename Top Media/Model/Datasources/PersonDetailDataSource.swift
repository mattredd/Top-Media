//
//  PersonDetailDataSource.swift
//  Top Media
//
//  Created by Matthew Reddin on 21/03/2022.
//

import SwiftUI
import Combine

class PersonDetailDataSource {
    
    let tableView: UITableView
    let dataSource: UITableViewDiffableDataSource<Int, MediaDetail>
    var cancellables: Set<AnyCancellable> = []
    let viewModel: PersonDetailViewModel
    
    init(tableView: UITableView, viewModel: PersonDetailViewModel, imageService: ImageService) {
        self.tableView = tableView
        self.viewModel = viewModel
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, personDetail in
            let cell = tableView.dequeueReusableCell(withIdentifier: "personCreditCell", for: indexPath)
            cell.textLabel?.text = personDetail.name ?? personDetail.title
            return cell
        })
        viewModel.$credits.receive(on: RunLoop.main).sink { [weak self] credits in
            self?.applyCredits(credits)
        }.store(in: &cancellables)
    }
    
    func applyCredits(_ credits: [MediaDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MediaDetail>()
        snapshot.appendSections([0])
        snapshot.appendItems(credits, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    
}
