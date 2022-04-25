//
//  MediaSearchViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 17/03/2022.
//

import UIKit
import Combine

enum MediaSearchType {
    case all, tv, films
}

class MediaSearchViewController: UITableViewController, UISearchResultsUpdating {
    
    static let identifier = "searchViewController"
    
    let viewModel: MediaSearchViewModel
    var dataSource: MediaSearchDataSource!
    let coordinator: SearchCoordinator
    var searchType: MediaSearchType = .all
    let messageLabel = UILabel()
    var cancellables: Set<AnyCancellable> = []
    
    required init?(coder: NSCoder, viewModel: MediaSearchViewModel, coordinator: SearchCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
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
        tableView.rowHeight = UITableView.automaticDimension
        let sc = UISearchController()
        sc.automaticallyShowsScopeBar = true
        sc.searchResultsUpdater = self
        sc.searchBar.scopeButtonTitles = ["All", "Films", "TV"]
        sc.searchBar.placeholder = "Search for Media"
        self.dataSource = MediaSearchDataSource(tableView: tableView, viewModel: viewModel)
        setupMessageLabel()
        navigationItem.title = "Search Media"
        navigationItem.searchController = sc
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            searchType = .all
        case 1:
            searchType = .films
        case 2:
            searchType = .tv
            
        default:
            searchType = .all
        }
        viewModel.searchParameters = (searchController.searchBar.text, searchType)
    }
    
    func setupMessageLabel() {
        messageLabel.textColor = .secondaryLabel
        view.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3)
        ])
    }
    
    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.numberOfSections == 1 {
            if let id = viewModel.media[searchType == .films ? 0 : 1][indexPath.item].id {
                coordinator.selectMedia(id: id, isFilm: searchType == .films)
            }
        } else {
            if let id = viewModel.media[indexPath.section][indexPath.item].id {
                coordinator.selectMedia(id: id, isFilm: indexPath.section == 0)
            }
        }
    }
}
