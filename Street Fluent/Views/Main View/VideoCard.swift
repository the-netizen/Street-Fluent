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
            thumbnailView

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
        .padding(6)
        .background(Color(.white).opacity(0.8))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary, lineWidth: 1)
        )
    }
    
    // MARK: - Thumbnail View
    var thumbnailView: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let uiImage = UIImage(named: video.thumbnailURL) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "play.fill")
                                    .font(style == .grid ? .title : .title3)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                    }
                }
                .aspectRatio(16/9, contentMode: .fit)
                .frame(width: style == .horizontal ? 120 : nil,
                       height: style == .horizontal ? 80 : nil)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if showLevelBadge {
                    Text(video.level.displayName)
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundColor(.tangerine)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                    
                    
                }
            }
            
            Text(video.formattedDuration)
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.vertical, 3)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.black.opacity(0.5))
                )
                .padding(.bottom, 6)
        }//z
    }//thumbnailView
    
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
