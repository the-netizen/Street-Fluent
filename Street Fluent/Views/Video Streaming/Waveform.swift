import SwiftUI

struct Waveform: View {
    let levels: [CGFloat] // array of 0.0-1.0. each level = 1 bar
    let isRecording: Bool // to toggle scroll/full view
    var playbackProgress: CGFloat  // what is being played/replayed
    
    var onDrag: ((CGFloat) -> Void)?
    var onTap: () -> Void

    private let barSpacing: CGFloat = 2
    
    var body: some View {
        GeometryReader { geo in
            if isRecording {
                // scrolling
                recordingWaveform(in: geo)
            } else {
                // playback
                playbackWaveform(in: geo)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
    } //geoReader
    
    private func recordingWaveform(in geo: GeometryProxy) -> some View {
            let barWidth: CGFloat = 5
            let availableWidth = geo.size.width
            let maxBars = Int(availableWidth / (barWidth + barSpacing))
            let visibleLevels = levels.suffix(maxBars)

            return HStack(alignment: .center, spacing: barSpacing) {
                // loop thru all audiolevels
                ForEach(Array(visibleLevels.enumerated()), id: \.offset) { _, level in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemBackground))
                        .frame(
                            width: barWidth,
                            // Bar height = level (0-1) × 80% of available height
                            // max(4) ensures even silent moments tiny bar
                            height: max(4, level * geo.size.height * 1.5)
                        )
                }
            }//hstack
//            .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the bars
            .frame(width: geo.size.width, height: geo.size.height, alignment: .trailing)
        }//recordingWaveform
    
    private func playbackWaveform(in geo: GeometryProxy) -> some View {
        let barWidth: CGFloat = 5
        let availableWidth = geo.size.width
        let maxBars = Int(availableWidth / (barWidth + barSpacing))
        let visibleLevels = levels.suffix(maxBars)
        
        return ZStack(alignment: .leading) {
            // All bars
            HStack(alignment: .center, spacing: barSpacing) {
                ForEach(Array(visibleLevels.enumerated()), id: \.offset) { index, level in
                    let barPosition = CGFloat(index) / CGFloat(max(visibleLevels.count, 1))
                    
                    let isPlayed = barPosition <= playbackProgress
                    
                    RoundedRectangle(cornerRadius: max(1, barWidth / 2))
                        .fill(isPlayed ? Color(.systemBackground) : Color(.systemBackground).opacity(0.3))
                        .frame(
                            width: barWidth,
                            height: max(3, level * geo.size.height * 1.5)
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            
        }
        // Drag gesture for scrubbing
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Convert finger position to 0.0-1.0 progress
                    let progress = min(max(value.location.x / geo.size.width, 0), 1)
                    onDrag?(progress)
                }
        )
    }
}

#Preview("Recording") {
    ZStack {
        Color.blue
        Waveform(
            levels: [0.1, 0.3, 0.8, 0.6, 0.9, 0.4, 0.7, 0.2, 0.5, 0.8,
                     0.3, 0.6, 0.4, 0.9, 0.2, 0.7, 0.5, 0.1, 0.8, 0.6],
            isRecording: true,
            playbackProgress: 0,
            onDrag: { progress in
                print("Dragged to progress: \(progress)")
            },
            onTap: {
                print("Waveform tapped")
            }
        )
        .frame(height: 150)
        .padding(.horizontal, 20)
    }
}
