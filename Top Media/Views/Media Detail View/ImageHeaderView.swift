//
//  ImageHeaderView.swift
//  Top Media
//
//  Created by Matthew Reddin on 17/03/2022.
//

import SwiftUI

// A stretchy image header for the media detail view
struct ImageHeaderView: View {
    
    @Environment(\.colorScheme) var colourScheme
    @Binding var image: UIImage?
    let contentOffset: Double
    let mainViewHeight: Double
    let mainViewCoordinateSpace: String
    let maxBlurRadius = 5.0
    let minimumHeight = 100.0
    let blurDivisor = 25.0
    let maxOverlayOpacity = 0.3
    
    var body: some View {
        GeometryReader { imageGeo in
            ZStack {
                Color.blue.opacity(0.5)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
            }
                .blur(radius: min(maxBlurRadius, abs(contentOffset) / blurDivisor), opaque: true)
                .frame(width: imageGeo.size.width, height: max(minimumHeight, mainViewHeight + contentOffset))
                .overlay(Color(.sRGB, white: colourScheme == .dark ? 0.2 : 0.8, opacity: min(maxOverlayOpacity, abs(contentOffset) / 100)))
                .clipped()
                .offset(x: 0, y: -contentOffset)
                .preference(key: ContentOffsetKey.self, value: imageGeo.frame(in: .named(mainViewCoordinateSpace)).origin.y)
        }
        .zIndex(1)
    }
}
