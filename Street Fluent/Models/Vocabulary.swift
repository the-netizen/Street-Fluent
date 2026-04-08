import Foundation

struct Vocabulary: Identifiable, Codable{
    
//  make it Hashable to use it in a Set or as a dictionary key.
    
//    let id: UUID
    let id: String
    let word: String
    let pinyin: String?
//    let meaning: String
    let definitions: [String] //each word has multiple defs
    let level: ProficiencyLevel?
    
//    var firstDefinition: String{
//        definitions.first ?? ""
//    }
    
}
