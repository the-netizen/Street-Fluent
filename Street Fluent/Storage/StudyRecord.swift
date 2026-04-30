import Foundation
import SwiftData

@Model
class VideoSession {
    var id: UUID
    var videoID: UUID
    var videoTitle: String
    var date: Date
    var dialoguesAttempted: Int  //how many tries user did
    var dialoguesTotal: Int
    var avgScore: Int
    
    var summaryText: String {
            "\(dialoguesAttempted)/\(dialoguesTotal) dialogues • \(avgScore)%"
        }
    
    init(videoID: UUID, videoTitle: String, dialoguesAttempted: Int,
         dialoguesTotal: Int, avgScore: Int) {
        self.id = UUID()
        self.videoID = videoID
        self.videoTitle = videoTitle
        self.date = Date()
        self.dialoguesAttempted = dialoguesAttempted
        self.dialoguesTotal = dialoguesTotal
        self.avgScore = avgScore
    }
}

@Model
class StudyRecord {
    var id: UUID
    var date: Date
    var sessions: [VideoSession] = [] //save sessions in array

    var didStudy: Bool { !sessions.isEmpty }
    
    // avg scores across all videos that day
    var dailyAvgScore: Int {
        guard !sessions.isEmpty else { return 0 }
        return sessions.map {
            $0.avgScore
        }.reduce(0, +) / sessions.count //all avg scores / all sessions
    }
    
    init(date: Date) {
            self.id = UUID()
            self.date = date
            self.sessions = []
        }
}

