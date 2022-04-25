//
//  MediaTrendItemConfiguration.swift
//  Top Media
//
//  Created by Matthew Reddin on 11/04/2022.
//

import UIKit

struct MediaTrendItemConfiguration: UIContentConfiguration {
    
    let mediaTrend: MediaDetail
    let large: Bool
    let imageService: ImageService
    let indexPosition: Int
    
    func makeContentView() -> UIView & UIContentView {
        return MediaTrendItemContentView(self, large: large, imageService: imageService)
    }
    func updated(for state: UIConfigurationState) -> MediaTrendItemConfiguration {
        return self
    }
}
