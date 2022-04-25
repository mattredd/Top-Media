//
//  UI Constants.swift
//  Top Media
//
//  Created by Matthew Reddin on 22/03/2022.
//

import Foundation
import UIKit

struct UIConstants {
    
    static let systemSpacing = 8.0
    static let compactSystemSpacing = 4.0
    static let cornerRadius = 10.0
    static let compactCornerRadius = 6.0
    static let strokeLineWidth = 2.0
    
}

extension UIView {

    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}
