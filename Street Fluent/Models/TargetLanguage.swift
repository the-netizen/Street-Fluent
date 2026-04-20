import Foundation

enum TargetLanguage: String, Identifiable, CaseIterable, Codable{
    
    var id: String {rawValue}  // uses rawValues "zh" "beginner' for identity
    
    case chinese = "zh"
    case english = "en"
    case arabic = "ar"
    
    var flag: String {
        switch self {
        case .chinese: return "🇨🇳"
        case .english: return "🇬🇧"
        case .arabic:  return "🇸🇦"
        }
    }
    
    var speechLocale: String {
        switch self {
        case .chinese: return "zh-CN"
        case .english: return "en-US"
        case .arabic:  return "ar-SA"
        }
    }
}
