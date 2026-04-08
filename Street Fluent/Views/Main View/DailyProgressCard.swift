import SwiftUI

struct DailyProgressCard: View {
    
    let selectedDate: Date
    private let calendar = Calendar.current
    private var record: StudyRecord {
        SampleData.studyRecord(for: selectedDate) ?? StudyRecord(
            id: UUID(), date: selectedDate,
            minutesStudied: 0, wordsReviewed: 0, wordsLearned: 0, videosWatched: 0
        )//sample data
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(selectedDate)
    }
    
    private var dateLabel: String {
        if isToday { return "Today" }
        if calendar.isDateInYesterday(selectedDate) { return "Yesterday" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d" //day, month, date
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Header
            HStack {
                Text(dateLabel)
                    .font(.headline)
                
                Spacer()
                
                // gotta update this
                if SampleData.currentStreak > 0 && isToday {
                    Label("\(SampleData.currentStreak)", systemImage: "flame.fill")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.tangerine)
                }
            }
            
            // stat blocks
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    vocabStats(
                        value: record.wordsLearned,
                        label: "New words",
                        icon: "plus.circle.fill",
                        color: .tangerine
                    )
                    vocabStats(
                        value: record.wordsReviewed,
                        label: "Reviewed",
                        icon: "arrow.triangle.2.circlepath",
                        color: .sage
                    )
                }
                HStack(spacing: 12) {
                    vocabStats(
                        value: record.minutesStudied,
                        label: "minutes",
                        icon: "clock.fill",
                        color: .orange
                    )
                    vocabStats(
                        value: record.videosWatched,
                        label: "Videos",
                        icon: "play.rectangle.fill",
                        color: .blue
                    )
                }
            }//v
        }//v
        .padding(16)
        .background(Color(.jeans))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemBackground), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
        
    private func vocabStats(value: Int, label: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            //icon
            Image(systemName: icon)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 3)
            
            Spacer().frame(width: 30)
            
            //stats info
            VStack(alignment: .center) {
                Text("\(value)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(color.opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemBackground), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 16) {
            DailyProgressCard(selectedDate: Date())
            DailyProgressCard(selectedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)
        }
        
    }
}
