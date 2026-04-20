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
        .padding(.top, 20)
        .frame(maxWidth: .infinity) //take all available space
        
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
                        viewModel.showTracingGuide.toggle()
                    } label: {
                        Image(systemName: viewModel.showTracingGuide ? "eye.slash" : "eye")
                            .font(.title3)
                    }
                    Spacer()
                    
                    // skip button - should skip words
                    Button {
                        viewModel.skipToNextWord()
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
            GeometryReader{ geo in
                
                let screenSize = min(geo.size.width, geo.size.height) //min for iphone
                
                ZStack{
                    //tracing guide
                    if viewModel.showTracingGuide, let word = viewModel.currentWord {
                        Text(word.word)
                            .font(.system(size: screenSize * 0.5)) //dynamic
                            .foregroundColor(Color.primary.opacity(50))
                            .allowsHitTesting(false) //lets touch pass thru to canvas
                    }
                    
                    WritingCanvas(viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
        VStack(spacing: 16) {
            if let score = viewModel.currentDialogueScore {
                Text("\(score)%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.tangerine)
                
            }
//            else {
//                Text("evaluating...")
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//            }
            
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
            .padding(.vertical, 30)
            
            
            Text(feedbackText)
                .font(.caption)
                .foregroundStyle(Color(.systemBackground))
                .multilineTextAlignment(.center)
                .lineLimit(.none)//??
                .padding(.horizontal, 20)
        }//v
    }// playback
    
    private var feedbackText: String {
        guard let score = viewModel.currentDialogueScore else {
            return " "
        }
        
        switch score {
        case 80...100: return "Great work! Your pronunciation is strong. 🎉"
        case 60...79:  return "Good effort! Keep practising to improve your tones."
        case 40...59:  return "Your pronunciation could be better. Please try again."
        default:       return "Don't give up! Listening and repeating is how you improve."
        }
    }
}

#Preview {
    PracticeArea(viewModel: VideoViewModel(video: SampleData.videos[0]))
}

#Preview {
    let vm = VideoViewModel(video: SampleData.videos[0])
    vm.currentDialogueScore = 85
    vm.recordingState = .finished
    vm.audioLevels = [0.3, 0.6, 0.8, 0.4, 0.9, 0.2, 0.7]
    return PracticeArea(viewModel: vm)
}
