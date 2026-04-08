import Foundation

enum TargetLanguage: String, Identifiable, CaseIterable, Codable{
    
    var id: String {rawValue}  // uses rawValues "zh" "beginner' for identity
    
    case chinese = "zh"
    case english = "en"
    case arabic = "ar"
    
}


enum ProficiencyLevel: String, Identifiable, CaseIterable, Codable{
    
    var id: String {rawValue}
    // why do i need this? aaaaa
    case beginner = "beginner"
    case elementary = "elementary"
    case intermediate = "intermediate"
    case advanced = "advanced"
    
    var displayName: String {
        switch self {
        case .beginner:     return "HSK 1-2"
        case .elementary:   return "HSK 3"
        case .intermediate: return "HSK 4"
        case .advanced:     return "HSK 5-6"
        }
    }
}

enum LearningMode: String, Codable { //enum allows state toggle, better than collection
    case speaking
    case writing
}

enum RecordingState {
    case idle
    case recording
    case finished
}
