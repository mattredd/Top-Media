//
//  MediaSearchCell.swift
//  Top Media
//
//  Created by Matthew Reddin on 17/03/2022.
//

import UIKit

class MediaSearchCell: UITableViewCell {
    
    static let identifier = "mediaSearchCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var asyncImage: AsyncImageView!
    @IBOutlet weak var extraInformationLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        asyncImage.layer.masksToBounds = true
        asyncImage.layer.cornerRadius = UIConstants.cornerRadius
        extraInformationLabel.font = UIFont.preferredFont(forTextStyle: .footnote, compatibleWith: UITraitCollection(legibilityWeight: .bold))
    }

}
