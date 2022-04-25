//
//  FavouritesViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 04/04/2022.
//

import UIKit
import Combine

class FavouritesViewController: UIViewController, UITableViewDelegate {
    
    let coordinator: FavouritesCoordinator
    let viewModel: FavouritesViewModel
    var datasource: FavouriteDatasource!
    var tableView = UITableView()
    var cancellables: Set<AnyCancellable> = []
    let messageLabel = UILabel()
    
    init(coordinator: FavouritesCoordinator, favouriteViewModel: FavouritesViewModel) {
        self.coordinator = coordinator
        self.viewModel = favouriteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: ViewController Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: FavouriteTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        datasource = FavouriteDatasource(tableView: tableView, viewModel: viewModel)
        setupMessageLabel()
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(boundsOf: view))
    }
    
    func setupMessageLabel() {
        messageLabel.text = "You do not have any Favourites\n\nYou can add an item to your favourites by clicking on the heart in the detail screen"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(messageLabel, aboveSubview: tableView)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        messageLabel.alpha = viewModel.favourites.count == 0 ? 1 : 0
        viewModel.$favourites.sink { [weak self] favs in
            guard let self = self else { return }
            if favs.count == 0 {
                self.messageLabel.alpha = 1
            } else {
                self.messageLabel.alpha = 0
            }
        }.store(in: &cancellables)
    }
    
    //MARK: Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator.selectMedia(favouriteMedia: viewModel.favourites[indexPath.row])
    }
    

}
