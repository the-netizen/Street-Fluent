// has subs data extracted from JSON
import Foundation

struct DictionaryEntry: Codable { //to decode the JSON
    let id: String
    let word: String
    let pinyin: String
    let definitions: [String]
    let level: String? // not every word has level
}

// For decoding subtitle JSON
struct SubtitleData: Codable {
    let dialogues: [DialogueData]
}

struct DialogueData: Codable {
    let index: Int
    let startTime: TimeInterval
    let endTime: TimeInterval
    let originalText: String
    let translatedText: String
    let wordIds: [String]         // references dictionary entries
}
