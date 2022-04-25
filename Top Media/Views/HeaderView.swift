//
//  HeaderView.swift
//  Top Media
//
//  Created by Matthew Reddin on 11/04/2022.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    let headerLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withSymbolicTraits(.traitBold)!, size: 0.0)
        headerLabel.textAlignment = .left
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}
