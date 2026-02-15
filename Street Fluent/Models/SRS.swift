import Foundation

struct SRS: Codable {
    
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
    
}
