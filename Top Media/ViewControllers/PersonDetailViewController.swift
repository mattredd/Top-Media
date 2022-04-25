//
//  PersonDetailViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import UIKit
import Combine

class PersonDetailViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var DOBLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var profilePictureView: AsyncImageView!
    @IBOutlet weak var biographyLabel: UITextView!
    @IBOutlet weak var mediaCreditsTableView: UITableView!
    let viewModel: PersonDetailViewModel
    var dataSource: PersonDetailDataSource!
    var cancellables: Set<AnyCancellable> = []
    let coordinator: PersonCoordinator
    
    init?(viewModel: PersonDetailViewModel, personCoordinator: PersonCoordinator, coder: NSCoder) {
        self.viewModel = viewModel
        self.coordinator = personCoordinator
        super.init(coder: coder)
        viewModel.$details.combineLatest(viewModel.$credits).receive(on: RunLoop.main).sink { [weak self] details, credits in
            self?.setupDetails(details: details)
        }.store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDetails(details: PersonInformation?) {
        if let details = details {
            profilePictureView?.imagePath = details.profilePath
            nameLabel?.text = details.name
            if let birthday = details.birthday, let placeOfBirth = details.placeOfBirth {
                DOBLabel?.text = birthday
                placeOfBirthLabel?.text = placeOfBirth
            }
            biographyLabel?.text = details.biography
            if biographyLabel?.text == nil || biographyLabel.text.isEmpty {
                biographyLabel?.text = "N/A"
            }
        }
    }
    
    //MARK: ViewController Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaCreditsTableView.delegate = self
        dataSource = PersonDetailDataSource(tableView: mediaCreditsTableView, viewModel: viewModel, imageService: viewModel.mediaService.imageService)
        profilePictureView.imageService = viewModel.mediaService.imageService
        profilePictureView.layer.cornerRadius = UIConstants.cornerRadius
        profilePictureView.layer.masksToBounds = true
        profilePictureView.imageSize = .large
    }
    
    
    
    //MARK: Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let credit = viewModel.credits[indexPath.item]
        if let id = credit.id {
            coordinator.selectCredit(id: id, isFilm: credit.isFilm ?? true)
        }
    }

}
