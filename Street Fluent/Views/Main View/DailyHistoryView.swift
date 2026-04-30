import SwiftUI
import SwiftData

struct DailyHistoryView: View {
    let selectedDate: Date
    
    @Query private var allSessions: [VideoSession]
    @State private var videoToStream: Video? = nil
    @State private var navigateToVideo = false
    
    private let calendar = Calendar.current
    
    // Filter sessions to selected date, look up Video object for each
    private var sessionsWithVideos: [(VideoSession, Video)] {
        allSessions
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .compactMap { session in
                // Look up video by ID — silently drops session if video not found
                guard let video = SampleData.video(for: session.videoID) else { return nil }
                return (session, video)
            }
    }
    
    private var dateLabel: String {
        if calendar.isDateInToday(selectedDate) { return "Today" }
        if calendar.isDateInYesterday(selectedDate) { return "Yesterday" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(dateLabel)
                .font(.headline)
                .padding(.horizontal, 16)
//                .frame(height: 24)
            
            if sessionsWithVideos.isEmpty {
                Spacer()
                Text("No sessions on this day.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(16)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 12) {
                        ForEach(sessionsWithVideos.reversed(), id: \.0.id) { session, video in
                            SessionCard(session: session, video: video)
                            //take 80% of screen
                                .frame(width: UIScreen.main.bounds.width * 0.80)
                                .onTapGesture {
                                    videoToStream = video
                                    navigateToVideo = true
                                }
                        }
                    }//h
                    .scrollTargetLayout() //snaps card into place
                    .padding(.horizontal, 16)
                }//scroll
                .scrollTargetBehavior(.viewAligned) // smooth card snapping
            }//else
        }//v
        .padding(.vertical, 12)
        .frame(height: 100) //fixed height
        .background(Color.jeans)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemBackground), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        // Navigate to video when card is tapped
        .navigationDestination(isPresented: $navigateToVideo) {
            if let video = videoToStream {
                VideoStreaming(video: video)
            }
        }
    }
}

private struct SessionCard: View {
    let session: VideoSession
    let video: Video
    
    var body: some View {
        HStack(spacing: 12) {
            
//            VideoCard(video: video, style: .horizontal, showLevelBadge: false).thumbnailView
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color(.systemBackground), lineWidth: 2)
//                ).frame(height:40)
            Text(video.title)
                           .font(.subheadline)
                           .fontWeight(.medium)
                           .foregroundStyle(.primary)
                           .lineLimit(2)
            
            Spacer()
            
            // score on the right
            VStack(spacing: 6) {
                // Mini semicircle gauge
                ZStack {
                    SemiCircleArcSmall()
                        .stroke(Color.white.opacity(0.2),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    
                    SemiCircleArcSmall()
                        .trim(from: 0, to: CGFloat(session.avgScore) / 100)
                        .stroke(scoreColor,
                                style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    
                    Text("\(session.avgScore)%")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .offset(y: 10)
                }
                .padding(10)
                
//                Text(session.summaryText)
//                    .font(.caption2)
//                    .foregroundStyle(.secondary)
//                    .multilineTextAlignment(.center)
            }//v
            .frame(width: 60)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity) //fills container
        .background(Color(.systemBackground).opacity(0.1))
        .cornerRadius(12)
    }
    
    private var scoreColor: Color {
        switch session.avgScore {
        case 80...100: return .green
        case 60...79:  return .tangerine
        default:       return .red
        }
    }
}

// Smaller version of SemiCircleArc for the session card
private struct SemiCircleArcSmall: Shape {
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
    NavigationStack {
        DailyHistoryView(selectedDate: Date())
            .modelContainer(for: VideoSession.self, inMemory: true)
    }
}
