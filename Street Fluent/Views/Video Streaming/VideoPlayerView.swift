import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var viewModel: VideoViewModel
    
    var body: some View {
        VStack(spacing: 0){
            
            // Video player
            if let player = viewModel.player { //if vid clicked and vidPlayer is created
                VideoPlayer(player: player) //from AVKit
                    .aspectRatio(16/9, contentMode: .fit)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay {
                        Text("Video not found")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
            }
            Rectangle().fill(.primary).frame(height: 3)

            // Subtitle row - tappable words
            HStack(spacing: 4) {
                ForEach(viewModel.currentWords) { word in
                    Button{
                        //each word is btn - popup dict when any word clicked
                    } label: {
                        Text(word.word)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            
            //linear dict popup
            
            // Translation row
            Text(viewModel.currentTranslation)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemBackground), lineWidth: 3)
        )
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    VideoPlayerView(viewModel: VideoViewModel(video: SampleData.videos[1]))
}
