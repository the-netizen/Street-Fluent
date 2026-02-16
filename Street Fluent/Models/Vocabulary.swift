import Foundation

struct Vocabulary: Identifiable, Codable{
    
//  make it Hashable to use it in a Set or as a dictionary key.
    
    let id: UUID
    let word: String
    let pinyin: String?
    let meaning: String
    let level: ProficiencyLevel?
    
}
