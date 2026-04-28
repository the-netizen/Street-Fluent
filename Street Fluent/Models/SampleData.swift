import Foundation

enum SampleData {
   
   
    static let videos: [Video] = [
//        Video(
//            id: UUID(), title: "新年快乐",
//            description: "Message to a friend for new years.",
//            thumbnailURL: "Sample-image-1.png", videoURL: "Sample-video-1",
//            duration: 19, language: .chinese, level: .beginner,
//            dialogues: SubtitleLoader.loadDialogues(for: "zh-subtitles-1"),
//            isFeatured: true, dateAdded: Date()
//        ),
        Video(
            id: UUID(), title: "中国人在吃披萨",
            description: "Trying Saudi pizza for the first time.",
            thumbnailURL: "Sample-image-2.jpeg", videoURL: "Sample-video-2",
            duration: 48, language: .chinese, level: .beginner,
            dialogues: SubtitleLoader.loadDialogues(for: "zh-subtitles-2"),
            isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        ),
        Video(
            id: UUID(), title: "和朋友去超市",
            description: "Describing my favourite food items in Saudi supermarket.",
            thumbnailURL: "Sample-image-3.png", videoURL: "Sample-video-3",
            duration: 44, language: .chinese, level: .beginner,
            dialogues: SubtitleLoader.loadDialogues(for: "zh-subtitles-3"), isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        ),
        Video(
            id: UUID(), title: "poem",
            description: "A Chinese poem about New years day from Song Dynasty.",
            thumbnailURL: "Sample-image-4.png", videoURL: "Sample-video-4",
            duration: 16, language: .chinese, level: .advanced,
            dialogues: SubtitleLoader.loadDialogues(for: "zh-subtitles-4"),
            isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        ),
        
        
        // === HSK 2 / Elementary ===
        Video(
            id: UUID(), title: "和朋友去超市",
            description: "Friends at a hotpot restaurant. Slang, jokes, and real conversational Mandarin.",
            thumbnailURL: "Sample-image-5.JPG", videoURL: "",
            duration: 198, language: .chinese, level: .elementary,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        ),
//        Video(
//            id: UUID(), title: "坐地铁去学校",
//            description: "Taking the subway to school. Directions, transportation words, and casual speech.",
//            thumbnailURL: "Sample-image-6.avif", videoURL: "",
//            duration: 167, language: .chinese, level: .elementary,
//            dialogues: [], isFeatured: false,
//            dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date())!
//        ),
        
        // === HSK 3 / Intermediate ===
//        Video(
//            id: UUID(), title: "和朋友去火锅店",
//            description: "Friends at a hotpot restaurant. Slang, jokes, and real conversational Mandarin.",
//            thumbnailURL: "Sample-image-6.JPG", videoURL: "",
//            duration: 428, language: .chinese, level: .intermediate,
//            dialogues: [], isFeatured: false,
//            dateAdded: Calendar.current.date(byAdding: .day, value: -12, to: Date())!
//        ),
//        Video(
//            id: UUID(), title: "租房子的经历",
//            description: "Apartment hunting in China. Useful vocabulary for housing, contracts, and negotiation.",
//            thumbnailURL: "Sample-image-7.jpg", videoURL: "",
//            duration: 315, language: .chinese, level: .intermediate,
//            dialogues: [], isFeatured: false,
//            dateAdded: Calendar.current.date(byAdding: .day, value: -15, to: Date())!
//        ),
        
        // === HSK 4 / Advanced ===
//        Video(
//            id: UUID(), title: "深圳科技公司面试",
//            description: "Trying a Chinese Hot pot Restaurant in Saudi Arabia. ",
//            thumbnailURL: "Sample-image-3.HEIC", videoURL: "",
//            duration: 540, language: .chinese, level: .advanced,
//            dialogues: [], isFeatured: false,
//            dateAdded: Calendar.current.date(byAdding: .day, value: -18, to: Date())!
//        ),
//        Video(
//            id: UUID(), title: "故宫历史讲解",
//            description: "Guided tour of the Forbidden City. Rich historical vocabulary and formal narration.",
//            thumbnailURL: "Sample-image-9.jpeg", videoURL: "",
//            duration: 390, language: .chinese, level: .advanced,
//            dialogues: [], isFeatured: false,
//            dateAdded: Calendar.current.date(byAdding: .day, value: -22, to: Date())!
//        ),
        // === English ===
        Video(
            id: UUID(), title: "Morning Routine",
            description: "Placeholder video in English.",
            thumbnailURL: "Sample-image-3.HEIC", videoURL: "",  // add real video later
            duration: 120, language: .english, level: .beginner,
            dialogues: [], isFeatured: true,
            dateAdded: Date()
        ),

        // === Arabic ===
        Video(
            id: UUID(), title: "في المطعم",
            description: "Placeholer Video in Arabic.",
            thumbnailURL: "Sample-image-11.HEIC", videoURL: "",
            duration: 90, language: .arabic, level: .beginner,
            dialogues: [], isFeatured: true,
            dateAdded: Date()
        ),
    ]
    
    static var featuredVideos: [Video] {
        videos.filter { $0.isFeatured }
    }
    
    static func videos(for level: ProficiencyLevel?) -> [Video] {
        guard let level else { return videos }
        return videos.filter { $0.level == level }
    }
}
