//
//  AboutViewController.swift
//  Top Media
//
//  Created by Matthew Reddin on 22/03/2022.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var requireTextLabel: UILabel!
    @IBOutlet weak var centreConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTrailingConstraint: NSLayoutConstraint!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centreConstraint?.isActive = false
        logoLeadingConstraint?.isActive = false
        logoTrailingConstraint?.isActive = false
        NSLayoutConstraint.activate([
            logoView.bottomAnchor.constraint(equalToSystemSpacingBelow: requireTextLabel.topAnchor, multiplier: 1),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3)
        ])
        UIViewPropertyAnimator(duration: 1, dampingRatio: 0.7) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }

}
