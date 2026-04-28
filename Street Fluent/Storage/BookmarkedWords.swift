import Foundation
import SwiftData

@Model
class BookmarkedWords {
    var wordId: String // to references og dictionary entry
    var word: String
    var pinyin: String
    var definitions: [String]
    var dateBookmarked: Date
    
    // SRS tracking
    var masteryLevel: MasteryLevel
    var lastReviewDate: Date?
    var nextReviewDate: Date
    
    init(from vocabulary: Vocabulary) { //default
        self.wordId = vocabulary.id
        self.word = vocabulary.word
        self.pinyin = vocabulary.pinyin ?? ""
        self.definitions = vocabulary.definitions
        self.dateBookmarked = Date()
        self.masteryLevel = .new
        self.lastReviewDate = nil
        // New words appear immediately
        self.nextReviewDate = Date()
    }
    
    enum MasteryLevel: Int, Codable{ //int so we can compare 0 < 1 < 2
        case new = 0      // not reviewed - repeat in 1/3 days
        case learning = 1 // reviewed - repeat in 1/7 days
        case known = 2    // learnt - repeat in 1/14 days
    }
    
    func markKnown() {
        lastReviewDate = Date()
        switch masteryLevel {
        case .new:
            masteryLevel = .learning //new -> learning
            nextReviewDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        case .learning:
            masteryLevel = .known   //learning -> known
            nextReviewDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        case .known:
            nextReviewDate = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        }
    }
    
    func markLearning() {
        lastReviewDate = Date()
        masteryLevel = .learning //stay learning. repeat next day
        nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
     
}


