//
//  FavouriteButtonStyle.swift
//  Books
//
//  Created by Matthew Reddin on 24/01/2022.
//

import SwiftUI
import CoreData

struct FavouriteButtonView: View {
    
    @Binding var isFavourite: Bool?
    @State private var scale = 0
    let animationDuration = 0.6
    
    var body: some View {
        ZStack {
            Group {
                Image(systemName: "heart")
                    .opacity(isFavourite != nil ? isFavourite! ? 0 : 1 : 1)
                Image(systemName: "heart.fill")
                    .opacity(isFavourite != nil ? isFavourite! ? 1 : 0 : 0)
                    .foregroundStyle(.pink)
            }
            .modifier(FavouriteHeartGeometryEffect(scale: Double(scale)))
            .animation(.spring(), value: isFavourite)
        }
        .onTapGesture {
            isFavourite?.toggle()
            scale += 1
        }
    }
}

struct FavouriteButtonView_Preview: PreviewProvider {
    static var previews: some View {
        FavouriteButtonView(isFavourite: .constant(true))
            .previewLayout(.fixed(width: 100, height: 100))
    }
}

