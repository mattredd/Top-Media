//
//  VideoListCellView.swift
//  Top Media
//
//  Created by Matthew Reddin on 12/04/2022.
//

import SwiftUI

struct VideoListCellView: View {
    
    let youtubeVideo: YoutubeVideo
    
    var body: some View {
        VStack {
            Text(youtubeVideo.snippet.title)
                .font(.title3.weight(.semibold))
                .lineLimit(3)
                .multilineTextAlignment(.center)
            Text(youtubeVideo.snippet.channelTitle)
                .font(.footnote)
                .foregroundColor(.secondary)
            VStack {
                AsyncImage(url: youtubeVideo.snippet.thumbnails[YoutubeVideoThumbnailOptions.medium.rawValue]!.url) { phase in
                    if let img = phase.image {
                        img
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .cornerRadius(UIConstants.cornerRadius)
                    } else if phase.error != nil {
                        Color.black
                    } else {
                        ProgressView()
                    }
                }
                HStack {
                    Text("**Views:** \(viewsString(from: youtubeVideo.statistics.viewCount))")
                    Text("**Duration:** \(durationFormatter(from: youtubeVideo.contentDetails.duration))")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
    
    func viewsString(from viewString: String) -> String {
        guard let viewsNumber = Int(viewString) else { return "" }
        switch viewsNumber {
        case 0..<1_000_000:
            return viewsNumber.formatted()
        case ..<1_000_000_000:
            return "\((Double(viewsNumber) / 1e6).formatted(.number.precision(.fractionLength(2))))M"
        default: return "\((Double(viewsNumber) / 1e9).formatted(.number.precision(.fractionLength(2))))B"
        }
    }
    
    func durationFormatter(from iso8601DurationString: String) -> String {
        let seconds = ISO8601Duration().convertToSeconds(isoString: iso8601DurationString)
        return "\(seconds / 60):\((seconds % 60).formatted(.number.precision(.integerLength(2))))"
    }
    
}
