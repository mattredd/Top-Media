//
//  RatingView.swift
//  Top Media
//
//  Created by Matthew Reddin on 06/04/2022.
//

import SwiftUI

struct RatingView: View {
    
    let rating: Double
    
    var body: some View {
        ZStack {
            Text("\(rating.formatted(.number.precision(.fractionLength(1))))")
                .bold()
                .foregroundColor(.white)
                .shadow(color: .yellow, radius: 3)
        }
        .padding(UIConstants.systemSpacing)
        .background(Circle().stroke(.white, lineWidth: UIConstants.strokeLineWidth).blur(radius: 2))
        .background(Circle().stroke(.yellow, lineWidth: UIConstants.strokeLineWidth))
        
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 8.79868)
            .previewLayout(.fixed(width: 150, height: 150))
            .background(.black)
    }
}
