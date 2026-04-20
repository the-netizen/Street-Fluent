import Foundation

struct VideoSession: Identifiable, Codable {
    let id: UUID
    let videoID: UUID
    let videoTitle: String
    let date: Date
    let dialoguesAttempted: Int  //how many tries user did
    let dialoguesTotal: Int
    var avgScore: Int
    
    var summaryText: String {
            "\(dialoguesAttempted)/\(dialoguesTotal) dialogues • \(avgScore)%"
        }
}

struct StudyRecord: Identifiable, Codable {
    let id: UUID
    let date: Date
    var sessions: [VideoSession]
    
    var didStudy: Bool {
        !sessions.isEmpty
    }
    
    // avg scores across all videos that day
    var dailyAvgScore: Int {
        guard !sessions.isEmpty else {
            return 0
        }
        return sessions.map {
            $0.avgScore
        }.reduce(0, +) / sessions.count //all avg scores / all sessions
    }
}

