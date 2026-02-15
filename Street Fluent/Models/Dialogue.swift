import Foundation

struct Dialogue: Identifiable, Codable {
    let id: UUID
    let index: Int                  // Order within the video (0-based)..
    let startTime: TimeInterval
    let endTime: TimeInterval
	let originalText: String
	let translatedText: String
    let words: [Vocabulary]
    
    // duration of 1 dialogue
    var segmentDuration: TimeInterval {
        endTime - startTime
    }
}
