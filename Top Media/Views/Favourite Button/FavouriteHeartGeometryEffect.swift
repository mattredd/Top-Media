//
//  FavouriteHeartGeoemtryEffect.swift
//  Books
//
//  Created by Matthew Reddin on 28/01/2022.
//

import SwiftUI

struct FavouriteHeartGeometryEffect: GeometryEffect {
    
    var scale: Double
    
    var animatableData: Double {
        get {
            scale
        }
        set {
            scale = newValue
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let frequency = 10.0
        let amplitude = 0.4
        let keyFrameScale = (sin(scale.truncatingRemainder(dividingBy: 1) / .pi * frequency) * amplitude) + 1
        var transform = CGAffineTransform(scaleX: keyFrameScale, y: keyFrameScale)
        transform = transform.translatedBy(x: -size.width / 2.0, y: -size.height / 2.0)
        transform = transform.concatenating(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))
        return ProjectionTransform(transform)
    }
    
    
}
