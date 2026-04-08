import Foundation

struct SRS: Identifiable, Codable {
    let id: UUID
    let wordId: String              // to references each dictionary entry
    let sourceVideoURL: String      // which video they found it in
    let dateBookmarked: Date
    
    var isBookmarked: Bool
    var timesReviewed: Int
    var lastReviewDate: Date?
    var masteryLevel: MasteryLevel
    
    enum MasteryLevel: Int, Codable{ //int so we can compare 0 < 1 < 2
        case new = 0
        case learning = 1
        case familiar = 2
        case mastered = 3
    }
    //for new bookmarked words
    init(wordId: String, sourceVideoURL: String) {
            self.id = UUID()
            self.wordId = wordId
            self.sourceVideoURL = sourceVideoURL
            self.dateBookmarked = Date()
            self.isBookmarked = true
            self.timesReviewed = 0
            self.lastReviewDate = nil
            self.masteryLevel = .new
        }
    
}
