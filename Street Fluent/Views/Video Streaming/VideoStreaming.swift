
import SwiftUI

struct VideoStreaming: View {
    let video: Video
    @State private var viewModel: VideoViewModel
    
    init(video: Video) {
        self.video = video
        self._viewModel = State(initialValue: VideoViewModel(video: video))
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                VideoPlayerView(viewModel: viewModel)
                PracticeArea(viewModel: viewModel)
            }//v
            .background(Color.bg)
            
            //score card when video finished
            if viewModel.showScoreCard {
                ScoreCardOverlay(viewModel: viewModel, video: video)
            }
        }//z
        .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded {
                    viewModel.selectedWord = nil
                }
            ) //dismiss dictionary popup when tapped anywhere
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // tap to switch between speaking nd writing
                Button {
                    viewModel.mode = (viewModel.mode == .speaking) ? .writing : .speaking
                } label: {
                    // icon changes based on current mode
                    Image(systemName: viewModel.mode == .speaking ? "pencil" : "mic.fill")
                }
            }
        }//toolbar
        .onAppear { viewModel.setupPlayer() }
        .onDisappear { viewModel.cleanup() } //wot?
    }
}
#Preview {
    VideoStreaming(video: SampleData.videos[2])
}
