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
            
//            VStack{
                // Subtitle row
                HStack(spacing: 4) {
                    ForEach(Array(viewModel.currentWords.enumerated()), id: \.offset) { index, word in
                        Button{
                            //dictionary pop-up
                            if viewModel.selectedWord?.id == word.id {
                                viewModel.selectedWord = nil
                            } else {
                                viewModel.selectedWord = word
                            }
                        } label: {
                            Text(word.word)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .background(
                                    //highlight in writing mode
                                    //tapped word should become bold
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            viewModel.mode == .writing && index == viewModel.currentWordsIndex
                                            ? Color.tangerine.opacity(0.4)
                                            : Color.clear
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }//h
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.top, 10)
                
                // Translation row
                Text(viewModel.currentTranslation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(15)
                    .overlay(alignment: .center) { //dictionary popup
                        if let word = viewModel.selectedWord {
                            DictionaryPopup(word: word) {
                                viewModel.selectedWord = nil
                            }
                            .simultaneousGesture(TapGesture().onEnded { }) // absorbs taps on the popup itself
                        }
                    }
                    .padding(.top, 3)
                    .padding(.bottom, 8)
                
        }//v
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemBackground), lineWidth: 3)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    VideoPlayerView(viewModel: VideoViewModel(video: SampleData.videos[2]))
}
