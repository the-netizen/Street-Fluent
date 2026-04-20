import Foundation

// Stores user preferences that persist across launches.

@Observable
class AppSettings {
    static let shared = AppSettings()
    
    var selectedLanguage: TargetLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    private init() {
        let saved = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "zh"
        selectedLanguage = TargetLanguage(rawValue: saved) ?? .chinese
    }
}
