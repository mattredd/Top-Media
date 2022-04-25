//
//  FavouriteCellTableViewCell.swift
//  Top Media
//
//  Created by Matthew Reddin on 04/04/2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    var asyncImage: AsyncImageView!
    var nameLabel = UILabel()
    static let identifier = "favouriteCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        asyncImage = AsyncImageView(path: nil, imageService: nil, imageSize: .medium)
        super.init(style: .default, reuseIdentifier: Self.identifier)
        addSubview(asyncImage)
        addSubview(nameLabel)
        asyncImage.contentMode = .scaleAspectFill
        asyncImage.clipsToBounds = true
        asyncImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        let heightConstraint = asyncImage.heightAnchor.constraint(equalToConstant: 150)
        heightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            heightConstraint,
            asyncImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            asyncImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 4),
            asyncImage.topAnchor.constraint(equalTo: topAnchor),
            asyncImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: asyncImage.trailingAnchor, multiplier: 1),
            nameLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        nameLabel.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [.textStyle: UIFont.TextStyle.title1]).withSymbolicTraits(.traitBold)!, size: 0)
        nameLabel.numberOfLines = 3
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
