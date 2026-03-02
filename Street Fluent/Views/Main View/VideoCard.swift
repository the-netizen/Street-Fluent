//
//  VideoCard.swift
//  Street Fluent
//
//  Created by Naima Khan on 16/02/2026.
//

import SwiftUI

enum VideoCardStyle {
    case horizontal
    case grid       
}

struct VideoCard: View {
    let video: Video
    let style: VideoCardStyle
    let showLevelBadge: Bool
    
    init(video: Video, style: VideoCardStyle = .horizontal) {
        self.video = video
        self.style = style
        self.showLevelBadge = true
    }
    
    //initializer for grid style
    init(video: Video, style: VideoCardStyle, showLevelBadge: Bool) {
        self.video = video
        self.style = style
        self.showLevelBadge = showLevelBadge
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Thumbnail
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(width: style == .horizontal ? 120 : nil, 
                               height: style == .horizontal ? 80 : nil)
                        .overlay {
                            Image(systemName: "play.fill")
                                .font(.title3)
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    
                    // Level badge - conditional
                    if showLevelBadge {
                        Text(video.level.displayName)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.tangerine)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 6)
                            .cornerRadius(4)
                    }
                }
                
                // Duration
                Text(video.formattedDuration)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .foregroundStyle(Color(.black))
                    .cornerRadius(4)
                    .padding(6)
            }
            
            // Title
            Text(video.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .lineLimit(2)
                .frame(
                    width: style == .horizontal ? 120 : nil,
                    alignment: .leading
                )
        }
        .padding(8)
        .background(Color(.white).opacity(0.8))
//        .border(Color.black, width: 2)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary, lineWidth: 1)
        )
    }
    
    
}

#Preview("Horizontal Style") {
    VideoCard(video: SampleData.videos.first!, style: .horizontal)
}

#Preview("Grid Style - With Badge") {
    VideoCard(video: SampleData.videos.first!, style: .grid, showLevelBadge: true)
}

#Preview("Grid Style - No Badge") {
    VideoCard(video: SampleData.videos.first!, style: .grid, showLevelBadge: false)
}
