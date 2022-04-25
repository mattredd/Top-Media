//
//  MainTabBarViewController.swift
//  F1 Stats
//
//  Created by Matthew Reddin on 08/03/2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    var homeCoordinator: HomeCoordinator?
    var searchCoordinator: SearchCoordinator?
    var personCoordinator: PersonCoordinator?
    var favouritesCoordinator: FavouritesCoordinator?
    let networkProvider = NetworkMediaProvider()
    let imageService: ImageService
    
    init(mainCoordinator: HomeCoordinator? = nil) {
        self.homeCoordinator = mainCoordinator
        self.imageService = ImageService(provider: self.networkProvider)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeCoordinator()
        setupSearchCoordinator()
        setupPersonCoordinator()
        setupFavouritesCoordinator()
        let aboutVC = UIStoryboard(name: "About", bundle: nil).instantiateViewController(withIdentifier: "aboutVC")
        aboutVC.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "info"), selectedImage: UIImage(systemName: "info"))
        self.viewControllers = [homeCoordinator!.navigationController, searchCoordinator!.navigationController, personCoordinator!.navigationController, favouritesCoordinator!.navigationController, aboutVC]
        homeCoordinator?.start()
        searchCoordinator?.start()
        personCoordinator?.start()
        favouritesCoordinator?.start()
    }
    
    //MARK: Load coordinators for each tab
    func setupHomeCoordinator() {
        let homeNavController = UINavigationController()
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        homeCoordinator = HomeCoordinator(imageProvider: imageService, networkProvider: networkProvider, navigationController: homeNavController)
    }
    
    func setupSearchCoordinator() {
        let searchNavController = UINavigationController()
        searchNavController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        searchCoordinator = SearchCoordinator(imageProvider: imageService, networkProvider: networkProvider, navigationController: searchNavController)
    }
    
    func setupPersonCoordinator() {
        let personNavController = UINavigationController()
        personCoordinator = PersonCoordinator(imageProvider: imageService, networkProvider: networkProvider, navigationController: personNavController)
        personNavController.tabBarItem = UITabBarItem(title: "People", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
    }
    
    func setupFavouritesCoordinator() {
        let favNavController  = UINavigationController()
        favouritesCoordinator = FavouritesCoordinator(imageProvider: imageService, networkProvider: networkProvider, navigationController: favNavController)
        favNavController.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart"))
    }

}
