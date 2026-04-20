//import SwiftUI
//
//struct DailyScoreCard: View {
//    let selectedDate: Date
//    private let calendar = Calendar.current
//    
//    private var record: StudyRecord? {
//        SampleData.studyRecord(for: selectedDate)
//    }
//    
//    private var dateLabel: String {
//        if calendar.isDateInToday(selectedDate) { return "Today" }
//        if calendar.isDateInYesterday(selectedDate) { return "Yesterday" }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE, MMM d"
//        return formatter.string(from: selectedDate)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            
//            // Header
//            HStack {
//                Text(dateLabel)
//                    .font(.headline)
//                Spacer()
//                if let record, record.didStudy {
//                    // Overall daily score badge
//                    Text("\(record.dailyAvgScore)%")
//                        .font(.caption)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.tangerine)
//                }
//            }
//            
//            if let record, !record.sessions.isEmpty {
//                // One row per video session
//                ForEach(record.sessions) { session in
//                    SessionRow(session: session)
//                }
//            } else {
//                // No study that day
//                Text("No sessions recorded")
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.vertical, 8)
//            }
//        }
//        .padding(16)
//        .background(Color(.jeans))
//        .cornerRadius(15)
//        .overlay(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(Color(.systemBackground), lineWidth: 1)
//        )
//        .padding(.horizontal, 16)
//    }
//}
//
//// One video session row
//private struct SessionRow: View {
//    let session: VideoSession
//    
//    var body: some View {
//        HStack {
//            // Score circle
//            ZStack {
//                Circle()
//                    .fill(scoreColor.opacity(0.2))
//                    .frame(width: 44, height: 44)
//                Text("\(session.avgScore)")
//                    .font(.caption)
//                    .fontWeight(.bold)
//                    .foregroundStyle(scoreColor)
//            }
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text(session.videoTitle)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                Text(session.summaryText)
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//            }
//            
//            Spacer()
//        }
//        .padding(10)
//        .background(Color(.systemBackground).opacity(0.15))
//        .cornerRadius(10)
//    }
//    
//    // Color reflects score quality
//    private var scoreColor: Color {
//        switch session.avgScore {
//        case 80...100: return .green
//        case 60...79:  return .tangerine
//        default:       return .red
//        }
//    }
//}
//
//#Preview {
//    DailyScoreCard(selectedDate: Date())
//}
