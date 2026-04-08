import SwiftUI
import AVKit  // gives VideoPlayer view

struct PracticeArea: View {
    var viewModel: VideoViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            controlBar
            Rectangle().fill(Color(.systemBackground).opacity(0.8)).frame(height: 3) //divider

            if viewModel.mode == .speaking{
                speakingArea
            } else {
                writingArea
            }
        }
        .background(.road)
        .clipShape(RoundedRectangle(cornerRadius: 20)) //box container
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemBackground), lineWidth: 3)
        )//border
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity) //take all available space
        
    }
    
    private var controlBar: some View {
            HStack {
                if viewModel.mode == .speaking {
                    //reset button
                    Button {
                        viewModel.resetRecording()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title3)
                            .foregroundColor(Color(.systemBackground))
                    }
                                        
                    Spacer()
                    
                    // skip button
                    Button {
                        viewModel.skipToNextDialogue()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                    }
                    
                }
                // writing mode
                else {
                    //reset button - should clear canvas
                    Button {
                        viewModel.clearCanvas()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    // toggle tracing help
                    Button {
                        viewModel.clearCanvas()
                    } label: {
                        Image(systemName: "eye") // or eye.slash
                            .font(.title3)
                    }
                    Spacer()
                    
                    // skip button - should skip words
                    Button {
                        viewModel.skipToNextDialogue()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                    }
                }
            }
            .foregroundStyle(Color(.systemBackground))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    
    private var speakingArea: some View {
           VStack(spacing: 16) {
               Spacer()
               
               if viewModel.recordingState == .idle {
                   micButton
               } else {
                   recordingPlayback
               }
              
               Spacer()
               
               if viewModel.hasDialogues {
                   Text(viewModel.dialogueProgress)
                       .font(.caption2)
                       .foregroundStyle(.tertiary)
                       .padding(.bottom, 10)
               }
           }
           .frame(maxWidth: .infinity)
       } //speakin area
              
    
        private var writingArea: some View {
            VStack(spacing: 0){
                WritingCanvas(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } //writing area
    
    
    private var micButton: some View{
        VStack{
            Spacer()
            Button {
                switch viewModel.recordingState {
                case .idle:
                    viewModel.startRecording()
                case .recording:
                    viewModel.stopRecording()
                case .finished:
                    break //tapping mic does nth
                }
                
            } label: {
                Image(systemName: recordingIcon)
                    .font(.system(size: 100))
                    .foregroundColor(.tangerine)
            }
            .disabled(!viewModel.isVideoPaused)
            .opacity(viewModel.isVideoPaused ? 1 : 0.3)

            Spacer()
            
//            Text(micHintText)
//                .font(.caption)
//                .foregroundStyle(.secondary)
        }
    } //mic
    
    private var recordingIcon: String {
        switch viewModel.recordingState {
        case .idle:      
            return "mic.fill"
        case .recording:
            return "stop.circle.fill"  // tap to stop
        case .finished:
            return "mic.fill"           // greyed out
        }
    }

    
    private var recordingPlayback: some View {
        HStack{
            if viewModel.recordingState == .finished {
                Button {
                    if viewModel.isPlayingBack {
                        viewModel.stopPlayback()
                    } else {
                        viewModel.startPlayback()
                    }
                } label: {
                    Image(systemName: viewModel.isPlayingBack ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.tangerine)
                }
            }
            Spacer()
            Waveform(
                levels: viewModel.audioLevels,
                isRecording: viewModel.recordingState == .recording,
                playbackProgress: viewModel.playbackProgress,
                onDrag: { progress in
                    // only allow scrubbing when playback is active
                    if viewModel.recordingState == .finished {
                        viewModel.seekPlayback(to: progress)
                    }
                },
                onTap: {
                    if viewModel.recordingState == .recording {
                        viewModel.stopRecording()
                    } //stop rec on tap
                }
            )
        }//h
        .frame(height: 100)
        .padding(.horizontal, 20)
    }// playback
}

#Preview {
    PracticeArea(viewModel: VideoViewModel(video: SampleData.videos[0]))
}
