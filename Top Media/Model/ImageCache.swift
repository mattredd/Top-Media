//
//  ImageProvider.swift
//  Books
//
//  Created by Matthew Reddin on 25/01/2022.
//

import Foundation
import UIKit

struct ImageCache {
    
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    func fetchImage(path: String, size: ImageSize) -> UIImage? {
        cache.object(forKey: (path + size.rawValue) as NSString)
    }
    
    func setImage(for path: String, img: UIImage, size: ImageSize) {
        cache.setObject(img, forKey: (path + size.rawValue) as NSString)
    }
}
