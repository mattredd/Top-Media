//
//  MediaTrendCellView.swift
//  Top Media
//
//  Created by Matthew Reddin on 10/03/2022.
//

import UIKit
import SwiftUI

class MediaCollectionViewCell: UICollectionViewCell {}

class MediaTrendItemContentView : UIView, UIContentView {
    
    let titleLabel = UILabel()
    let large: Bool
    let asyncImageView: AsyncImageView
    let imageService: ImageService
    let indexLabel = UILabel()
    var shadowLayer: CAShapeLayer!
    var configuration: UIContentConfiguration {
        didSet {
            self.configure(configuration: configuration)
        }
    }
    
    var paragraphStyle: NSParagraphStyle = {
        $0.hyphenationFactor = 1.0
        $0.alignment = .center
        return $0
    }(NSMutableParagraphStyle())
    
    init(_ configuration: UIContentConfiguration, large: Bool, imageService: ImageService) {
        self.configuration = configuration
        self.large = large
        self.imageService = imageService
        self.asyncImageView = AsyncImageView(path: nil, imageService: imageService, imageSize: .medium)
        super.init(frame: .infinite)
        configureTitleLabel()
        configureAsyncImage()
        configureIndexLabel()
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer != nil && shadowLayer.frame != .infinite {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: UIConstants.cornerRadius).cgPath
            shadowLayer.shadowPath = shadowLayer.path
            return
        }
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: UIConstants.cornerRadius).cgPath
        shadowLayer.fillColor = UIColor(named: "cellBackgroundColour")!.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 7, height: 7)
        shadowLayer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0 : 0.4
        shadowLayer.shadowRadius = 5
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            asyncImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            asyncImageView.topAnchor.constraint(equalTo: topAnchor),
            asyncImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            asyncImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: asyncImageView.trailingAnchor, multiplier: 1),
            indexLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            indexLabel.layoutMarginsGuide.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        shadowLayer.shadowOpacity = traitCollection.userInterfaceStyle != .dark ? 0.4 : 0.0
        shadowLayer.fillColor = UIColor(named: "cellBackgroundColour")!.cgColor
    }
    
    func configureIndexLabel() {
        addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).withSymbolicTraits(.traitBold)!, size: 0.0)
        indexLabel.textColor = .lightGray
    }
    
    func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    func configureAsyncImage() {
        addSubview(asyncImageView)
        asyncImageView.contentMode = .scaleAspectFill
        asyncImageView.translatesAutoresizingMaskIntoConstraints = false
        asyncImageView.clipsToBounds = true
        asyncImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        asyncImageView.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? MediaTrendItemConfiguration else { return }
        let attributedText = NSMutableAttributedString(string: configuration.mediaTrend.title ?? configuration.mediaTrend.originalTitle ?? configuration.mediaTrend.name ?? configuration.mediaTrend.originalName ?? "")
        let stringRange = NSRange(attributedText.string.startIndex..<attributedText.string.endIndex, in: attributedText.string)
        let titleLabelFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: [.textStyle : (configuration.large ? UIFont.TextStyle.title1 : UIFont.TextStyle.title3)]).withSymbolicTraits(.traitBold)!, size: 0)
        attributedText.setAttributes([.font : titleLabelFont, .paragraphStyle: paragraphStyle], range: stringRange)
        self.titleLabel.attributedText = attributedText
        self.asyncImageView.imageSize = .medium
        if configuration.mediaTrend.posterPath != self.asyncImageView.imagePath {
            self.asyncImageView.imagePath = configuration.mediaTrend.posterPath
        }
        indexLabel.text = "\(configuration.indexPosition)"
        if shadowLayer != nil && shadowLayer.frame != .infinite {
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: UIConstants.cornerRadius).cgPath
            shadowLayer.shadowPath = shadowLayer.path
        }
    }
}
