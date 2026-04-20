import SwiftUI

// Full screen overlay shown when user completes a video.
// Dims content underneath, shows scorecard in centre.
// Tapping outside the card dismisses it.
struct ScoreCardOverlay: View {
    var viewModel: VideoViewModel
    let video: Video
    
    var body: some View {
        ZStack {
            // Dimmed background — tap to dismiss
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showScoreCard = false
                }
            
            scoreCard
                .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.showScoreCard)
    }
    
    // MARK: - Score Card
    
    private var scoreCard: some View {
        VStack(spacing: 0) {
            gaugeSection
                .padding(.vertical, 50)
            
            
            statsSection
                .padding(24)
        }
        .background(Color.jeans)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemBackground), lineWidth: 3)
        )
        .padding(.horizontal, 24)
    }
    
    // MARK: - Gauge
    
    private var gaugeSection: some View {
        ZStack {
            // Background arc
            SemiCircleArc()
                .stroke(Color.white.opacity(0.2), lineWidth: 16)
            
            // Progress arc
            SemiCircleArc()
                .trim(from: 0, to: CGFloat(viewModel.overallScore) / 100)
                .stroke(scoreColor, lineWidth: 16)
                .animation(.easeInOut(duration: 0.8), value: viewModel.overallScore)
            
            Text("\(viewModel.overallScore)%")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .offset(y: 35)
            
        }
        .frame(width: 220, height: 120)
    }
    
    private var scoreColor: Color {
        switch viewModel.overallScore {
        case 80...100: .green
        case 60...79: .yellow  
        case 40...59: .orange
        default: .red
        }
    }
    
    // MARK: - Stats
    
    private var statsSection: some View {
        VStack(spacing: 50) {
            VStack(spacing: 10) {
                statRow(label: "Dialogues spoken",
                        value: "\(viewModel.perDialogueScores.count)/\(video.dialogues.count)")
                statRow(label: "Accuracy",
                        value: "\(viewModel.overallScore)%")
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.showScoreCard = false
                    viewModel.restartVideo()
                }) {
                    Text("Try again")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.tangerine)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button(action: {
                    viewModel.showScoreCard = false
                    //save the score to display on mainView
                    //go back to mainView
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.sage)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }//h
        }
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
        }
    }
}

// Draws the top half of a circle left → right
private struct SemiCircleArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ScoreCardOverlay(
            viewModel: {
                let vm = VideoViewModel(video: SampleData.videos[2])
                vm.perDialogueScores = [0: 82, 1: 61, 2: 74]
                vm.showScoreCard = true
                return vm
            }(),
            video: SampleData.videos[2]
        )
    }
}
