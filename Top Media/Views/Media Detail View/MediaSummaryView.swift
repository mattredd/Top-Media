//
//  Capsule.swift
//  Top Media
//
//  Created by Matthew Reddin on 03/04/2022.
//

import SwiftUI

struct MediaSummaryView: View {
    
    @Binding var isFavourite: Bool?
    @Binding var showVideos: Bool
    @Binding var showCast: Bool
    @Binding var networkImage: UIImage?
    let mediaDetail: MediaDetail
    let isFilm: Bool
    let backgroundGradientColours = [Gradient.Stop(color: Color(red: 0.1, green: 0.1, blue: 0.2), location: 0.1), .init(color: Color(red: 0.1, green: 0.1, blue: 0.3), location: 0.5), .init(color: Color(red: 0.1, green: 0.1, blue: 0.5), location: 0.9)]
    
    var body: some View {
        VStack {
            VStack(spacing: UIConstants.compactSystemSpacing) {
                Text(mediaDetail.title ?? (mediaDetail.name ?? "-"))
                    .font(.largeTitle.weight(.semibold))
                    .multilineTextAlignment(.center)
                if let tagline = mediaDetail.tagline, !tagline.isEmpty {
                    Text(tagline)
                        .font(.footnote.weight(.semibold))
                }
                if let genres = mediaDetail.genres {
                    Text(genres.map(\.name).compactMap({ $0 }).formatted())
                        .multilineTextAlignment(.center)
                        .font(.footnote.weight(.semibold))
                }
                
            }.frame(maxWidth: .infinity)
                .shadow(radius: UIConstants.compactCornerRadius)
            HStack(spacing: UIConstants.systemSpacing * 2) {
                if let rating = mediaDetail.voteAverage, rating != 0 {
                    VStack(spacing: UIConstants.compactSystemSpacing) {
                        RatingView(rating: rating)
                        Text("Rating")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                VStack(spacing: UIConstants.compactSystemSpacing) {
                    FavouriteButtonView(isFavourite: $isFavourite)
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    Text("Favourite")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            if let status = mediaDetail.status {
                Text(status)
                    .bold()
                    .padding(UIConstants.compactSystemSpacing)
                    .background(RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius).stroke(lineWidth: UIConstants.strokeLineWidth))
                    .foregroundColor(.blue)
                    .brightness(0.2)
                    .padding(.bottom, UIConstants.compactSystemSpacing)
            }
            mediaSpecificSummary
            HStack(spacing: UIConstants.systemSpacing * 2) {
                Button {
                    showCast = true
                } label: {
                    VStack(spacing: 0) {
                        Image(systemName: "person.circle")
                        Text("Cast")
                            .font(.caption)
                    }
                }
                if (mediaDetail.videos?.results.count ?? 0) != 0 {
                    Button {
                        showVideos = true
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: "film.circle")
                            Text("Videos")
                                .font(.caption)
                        }
                    }
                }
            }
            .font(.largeTitle)
            .foregroundColor(.accentColor)
            .padding(UIConstants.compactSystemSpacing)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.linearGradient(stops: backgroundGradientColours, startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(.white)
    }
    
    var mediaSpecificSummary: some View {
        VStack(spacing: UIConstants.systemSpacing) {
            if isFilm {
                if let releaseDate = mediaDetail.releaseDate, let runtime = mediaDetail.runtime, runtime != 0 {
                    HStack {
                        Spacer()
                        VStack {
                            Text(releaseDate.formatted(date: .numeric, time: .omitted))
                                .font(.title3.weight(.semibold))
                            Text("Release Date")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack {
                            Text("\(runtime / 60) hrs \(runtime % 60) mins")
                                .font(.title3.weight(.semibold))
                            Text("Runtime")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                }
            } else {
                VStack(spacing: UIConstants.systemSpacing) {
                    if let networks = mediaDetail.networks {
                        HStack {
                            if let networkImage = networkImage {
                                Image(uiImage: networkImage)
                                    .padding(UIConstants.compactSystemSpacing)
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: UIConstants.compactCornerRadius))
                            }
                            Text(networks.lazy.map(\.name!).formatted())
                                .bold()
                        }
                    }
                    HStack {
                        if let seasons = mediaDetail.seasons, let firstAirDate = mediaDetail.firstAirDate {
                            let numberOfEpisodes = seasons.lazy.map(\.episodeCount!).reduce(0, +)
                            let yearFirstAired = firstAirDate[..<(firstAirDate.firstIndex(of: "-") ?? firstAirDate.endIndex)]
                            VStack {
                                Text("\(seasons.count)")
                                    .font(.title.weight(.semibold))
                                Text("Seasons")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            Divider()
                                .background(.secondary)
                            VStack {
                                Text("\(numberOfEpisodes)")
                                    .font(.title.weight(.semibold))
                                Text("Episodes")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                
                            }
                            Divider()
                                .background(.secondary)
                            VStack {
                                Text("\(String(yearFirstAired))")
                                    .font(.title.weight(.semibold))
                                Text("First Aired")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
