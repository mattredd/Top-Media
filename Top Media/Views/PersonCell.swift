//
//  PersonCell.swift
//  Top Media
//
//  Created by Matthew Reddin on 20/03/2022.
//

import UIKit

class PersonCell: UICollectionViewCell {}

class PersonContentView : UIView, UIContentView {
    
    let imageService: ImageService
    let personNameLabel = UILabel()
    let labelBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let asyncImageView: AsyncImageView
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }

    
    init(_ configuration: UIContentConfiguration, imageService: ImageService) {
        self.configuration = configuration
        self.imageService = imageService
        self.asyncImageView = AsyncImageView(path: nil, imageService: (configuration as! PersonContentConfiguration).imageService, imageSize: .medium)
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        configureSubviews()
        applyConstraints()
        personNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.2)
        layer.cornerRadius = UIConstants.cornerRadius
        layer.masksToBounds = true
    }
    
    func configureSubviews() {
        asyncImageView.translatesAutoresizingMaskIntoConstraints = false
        asyncImageView.addSubview(labelBackgroundView)
        asyncImageView.contentMode = .scaleAspectFill
        addSubview(asyncImageView)
        personNameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        labelBackgroundView.contentView.addSubview(personNameLabel)
        labelBackgroundView.contentView.layoutMargins = .init(top: UIConstants.systemSpacing, left: UIConstants.systemSpacing, bottom: UIConstants.systemSpacing, right: UIConstants.systemSpacing)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate(asyncImageView.constraintsForAnchoringTo(boundsOf: self))
        NSLayoutConstraint.activate([
            labelBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            personNameLabel.topAnchor.constraint(equalTo: labelBackgroundView.contentView.layoutMarginsGuide.topAnchor),
            personNameLabel.bottomAnchor.constraint(equalTo: labelBackgroundView.contentView.layoutMarginsGuide.bottomAnchor),
            personNameLabel.leadingAnchor.constraint(equalTo: labelBackgroundView.contentView.layoutMarginsGuide.leadingAnchor),
            personNameLabel.trailingAnchor.constraint(equalTo: labelBackgroundView.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        personNameLabel.text = (configuration as! PersonContentConfiguration).person.name
        asyncImageView.imagePath = (configuration as! PersonContentConfiguration).person.profilePath
    }
}


