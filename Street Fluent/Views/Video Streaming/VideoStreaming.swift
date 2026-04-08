
import SwiftUI

struct VideoStreaming: View {
    let video: Video
    @State private var viewModel: VideoViewModel
    
    init(video: Video) {
        self.video = video
        self._viewModel = State(initialValue: VideoViewModel(video: video))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 0) {
                // video streaming area
                VideoPlayerView(viewModel: viewModel)
                
                PracticeArea(viewModel: viewModel)
                
            }
            .background(Color.bg)
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
            }
            .onAppear { viewModel.setupPlayer() }
            .onDisappear { viewModel.cleanup() } //wot?
        }
    }
}
#Preview {
    VideoStreaming(video: SampleData.videos[0])
}
