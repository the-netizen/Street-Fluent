import Foundation

// For decoding subtitle JSON
struct DictionaryEntry: Codable {
    let id: String
    let word: String
    let pinyin: String
    let definitions: [String]
    let level: String? // not every word has level
}

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
