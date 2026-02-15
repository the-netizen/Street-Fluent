import Foundation


struct Video: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let thumbnailURL: String        // URL or local asset name
    let videoURL: String            // URL to video file (local or remote)
    let duration: TimeInterval      // Total duration in seconds
    let language: TargetLanguage
    let level: ProficiencyLevel
//    let tags: [String]              // e.g., ["slang", "food", "travel"] not needed now
    let dialogues: [Dialogue]       // Ordered list of dialogue segments
    let isFeatured: Bool            // Show on home screen
    let dateAdded: Date
    
    var fullTranscript: String { // for vid description view
        dialogues.map { $0.originalText }.joined(separator: "\n")
    }
}

enum TargetLanguage: String, Identifiable, CaseIterable, Codable{
    
    var id: String {rawValue}  // uses rawValues "zh" "beginner' as identity
    
    case chinese = "zh"
//    case english = "en"
//    case arabic = "ar"
//    case japanese = "jp"
    
    // i want ghost guide to always be available as an optional button feature for the users, regardless of the language..
    
}


enum ProficiencyLevel: String, Identifiable, CaseIterable, Codable{
    
    var id: String {rawValue}
    
    case beginner = "beginner"
    case elementary = "elementary"
    case intermediate = "intermediate"
    case advanced = "advanced"

}

enum LearningMode: String, Codable { //enum allows state toggle, better than collection
    case speaking
    case writing
}
