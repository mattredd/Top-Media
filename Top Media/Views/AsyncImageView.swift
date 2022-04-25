//
//  AsyncImageView.swift
//  Top Media
//
//  Created by Matthew Reddin on 10/03/2022.
//

import UIKit

class AsyncImageView: UIImageView {
    
    var imageService: ImageService?
    var imageSize: ImageSize
    var progressView = UIActivityIndicatorView()
    var imagePath: String? {
        didSet {
            fetchImage()
        }
    }
    
    func fetchImage() {
        self.image = nil
        if let imagePath = imagePath {
            progressView.startAnimating()
            Task {
                let imageData = try? await imageService?.fetchImage(path: imagePath, size: imageSize)
                if let imageData = imageData {
                    self.image = imageData
                }
                progressView.stopAnimating()
            }
        }
    }
    
    init(path: String?, imageService: ImageService?, imageSize: ImageSize) {
        self.imageService = imageService
        self.imageSize = imageSize
        super.init(frame: .zero)
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        backgroundColor = .gray
        fetchImage()
    }
    
    required init?(coder: NSCoder) {
        self.imageSize = .small
        super.init(coder: coder)
    }
}
