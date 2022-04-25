//
//  BookService.swift
//  Books
//
//  Created by Matthew Reddin on 25/01/2022.
//

import Foundation
import UIKit

class ImageService {
    
    var provider: ImageProvider
    let imageProvider = ImageCache.shared
    
    init(provider: MediaProvider) {
        self.provider = provider
    }
    
    func fetchImage(path: String, size: ImageSize) async throws -> UIImage? {
        if let imgData = imageProvider.fetchImage(path: path, size: size) {
            return imgData
        } else {
            if let imgData = try await provider.fetchImage(path: path, size: size), let image = await UIImage(data: imgData, scale: UIScreen.main.scale) {
                imageProvider.setImage(for: path, img: image, size: size)
                return image
            } else {
                return nil
            }
        }
    }
}
