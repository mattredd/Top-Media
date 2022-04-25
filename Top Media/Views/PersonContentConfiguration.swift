//
//  PersonContentConfiguration.swift
//  Top Media
//
//  Created by Matthew Reddin on 11/04/2022.
//

import UIKit

struct PersonContentConfiguration : UIContentConfiguration {
    
    let person: Person
    let imageService: ImageService
    
    func makeContentView() -> UIView & UIContentView {
        return PersonContentView(self, imageService: imageService)
    }
    func updated(for state: UIConfigurationState) -> PersonContentConfiguration {
        return self
    }
}
