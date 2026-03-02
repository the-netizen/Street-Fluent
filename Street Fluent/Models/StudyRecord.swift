import Foundation

struct StudyRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    var minutesStudied: Int
    var wordsReviewed: Int
    var wordsLearned: Int
    var videosWatched: Int
    
    var didStudy: Bool {
        minutesStudied > 0
    }
}
