// JSON loader
import Foundation

enum SubtitleLoader {
    
    // Cache the dictionary so we only load it once
    private static var dictionary: [String: Vocabulary] = {
        guard let url = Bundle.main.url(forResource: "zh-dictionary", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([DictionaryEntry].self, from: data)
        else {
            print("⚠️ zh-dictionary.json not found")
            return [:]
        }
        
        // Build a lookup table: id → Vocabulary
        var dict: [String: Vocabulary] = [:]
        for entry in entries {
            dict[entry.id] = Vocabulary(
                id: entry.id,
                word: entry.word,
                pinyin: entry.pinyin,
                definitions: entry.definitions,
                level: ProficiencyLevel(rawValue: entry.level ?? "")
            )
        }
        return dict
    }()
    
    /// Load dialogues for a video, resolving word IDs from the dictionary
    static func loadDialogues(for videoURL: String) -> [Dialogue] {
        guard let url = Bundle.main.url(forResource: videoURL, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let subtitleData = try? JSONDecoder().decode(SubtitleData.self, from: data)
        else {
            return []
        }
        
        return subtitleData.dialogues.map { d in
            // Look up each word ID in the dictionary
            let words = d.wordIds.compactMap { id in
                dictionary[id]
            }
            
            return Dialogue(
                id: UUID(),
                index: d.index,
                startTime: d.startTime,
                endTime: d.endTime,
                originalText: d.originalText,
                translatedText: d.translatedText,
                words: words
            )
        }
    }
    
    /// Get a word by its stable ID (for bookmarks)
    static func word(for id: String) -> Vocabulary? {
        dictionary[id]
    }
}
