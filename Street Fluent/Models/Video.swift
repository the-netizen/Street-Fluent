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
    
    var formattedDuration: String{
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
        
    }
    
    var fullTranscript: String { // for vid description view
        dialogues.map { $0.originalText }.joined(separator: "\n")
    }
}
