//
//  MediaDetailView.swift
//  Top Media
//
//  Created by Matthew Reddin on 16/03/2022.
//

import SwiftUI

struct MediaDetailView: View {
    
    @StateObject var mediaDetailVM: MediaDetailViewModel
    @State private var contentOffset = 0.0
    @State private var showTitle = false
    @State var imageTitleScreen: String? = nil
    @State private var showCredits = false
    @State private var showVideos = false
    @State private var isFavourite: Bool? = nil
    let mainViewCoordinateSpace = "MainView"
    let imageProportionalHeight = 0.6
    
    var body: some View {
        GeometryReader { mainGeo in
            ScrollView {
                VStack(spacing: 0) {
                    ImageHeaderView(image: $mediaDetailVM.image, contentOffset: contentOffset, mainViewHeight: mainGeo.size.height * imageProportionalHeight, mainViewCoordinateSpace: mainViewCoordinateSpace)
                        .frame(height: mainGeo.size.height * imageProportionalHeight)
                        .allowsHitTesting(false)
                        if let mediaDetail = mediaDetailVM.media {
                            MediaSummaryView(isFavourite: $isFavourite, showVideos: $showVideos, showCast: $showCredits, networkImage: $mediaDetailVM.networkImage, mediaDetail: mediaDetail, isFilm: mediaDetailVM.isFilm)
                        }
                    Group {
                        if let overview = mediaDetailVM.media?.overview {
                            Text("Overview")
                                .font(.title.weight(.semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, UIConstants.systemSpacing)
                            Text(overview)
                                .padding(.bottom)
                        }
                    }
                    .padding(.horizontal)
                }
                .onPreferenceChange(ContentOffsetKey.self) { prev in
                    contentOffset = prev
                }
                .onChange(of: isFavourite) { [isFavourite] newValue in
                    mediaDetailVM.favouriteChanged(oldValue: isFavourite, newValue: newValue)
                }
            }
            .coordinateSpace(name: mainViewCoordinateSpace)
            .navigationTitle(mediaDetailVM.media?.name ?? mediaDetailVM.media?.title ?? "")
            .task { [weak mediaDetailVM] in
                await mediaDetailVM?.fetchMediaDetail()
                isFavourite = mediaDetailVM?.loadFavourite()
            }
        }
        .sheet(isPresented: $showCredits) {
            CreditList(creditListVM: CreditListViewModel(creditList: mediaDetailVM.credits, service: mediaDetailVM.mediaService, coordinator: mediaDetailVM.coordinator))
        }
        .sheet(isPresented: $showVideos) {
            VideosListView(viewModel: VideosViewModel(service: YoutubeService(youtubeProvider: NetworkYoutubeProvider()), videos: mediaDetailVM.media?.videos?.results))
        }
    }
}

struct ContentOffsetKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
