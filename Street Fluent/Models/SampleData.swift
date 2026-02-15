import Foundation

enum SampleData {

    static let sampleDialogues: [Dialogue] = [
        Dialogue(
            id: UUID(),
            index: 0,
            startTime: 0.0,
            endTime: 3.2,
            originalText: "大家 好",
            translatedText: "Hello everyone",
            words: [
                Vocabulary(id: UUID(), word: "大家", pinyin: "dàjiā", meaning: "everyone", level: .beginner),
                Vocabulary(id: UUID(), word: "好", pinyin: "hǎo", meaning: "good; hello", level: .beginner),
            ]
        ),
        Dialogue(
            id: UUID(),
            index: 1,
            startTime: 3.2,
            endTime: 6.8,
            originalText: "欢迎 来到 我的 频道",
            translatedText: "Welcome to my channel",
            words: [
                Vocabulary(id: UUID(), word: "欢迎", pinyin: "huānyíng", meaning: "welcome", level: .beginner),
                Vocabulary(id: UUID(), word: "来到", pinyin: "láidào", meaning: "to come to; to arrive", level: .beginner),
                Vocabulary(id: UUID(), word: "我的", pinyin: "wǒ de", meaning: "my; mine", level: .beginner),
                Vocabulary(id: UUID(), word: "频道", pinyin: "píndào", meaning: "channel", level: .elementary),
            ]
        ),
        Dialogue(
            id: UUID(),
            index: 2,
            startTime: 6.8,
            endTime: 11.5,
            originalText: "今天 我 带 你们 去 吃 北京 烤鸭",
            translatedText: "Today I'll take you to eat Beijing roast duck",
            words: [
                Vocabulary(id: UUID(), word: "今天", pinyin: "jīntiān", meaning: "today", level: .beginner),
                Vocabulary(id: UUID(), word: "我", pinyin: "wǒ", meaning: "I; me", level: .beginner),
                Vocabulary(id: UUID(), word: "带", pinyin: "dài", meaning: "to take; to bring", level: .beginner),
                Vocabulary(id: UUID(), word: "你们", pinyin: "nǐmen", meaning: "you (plural)", level: .beginner),
                Vocabulary(id: UUID(), word: "去", pinyin: "qù", meaning: "to go", level: .beginner),
                Vocabulary(id: UUID(), word: "吃", pinyin: "chī", meaning: "to eat", level: .beginner),
                Vocabulary(id: UUID(), word: "北京", pinyin: "Běijīng", meaning: "Beijing", level: .beginner),
                Vocabulary(id: UUID(), word: "烤鸭", pinyin: "kǎoyā", meaning: "roast duck", level: .elementary),
            ]
        ),
    ]

    // MARK: - Sample Videos

    static let videos: [Video] = [
        Video(
            id: UUID(),
            title: "北京美食之旅",
            description: "Follow a local foodie through Beijing's famous food streets. Learn common food vocabulary and ordering phrases used in real restaurants.",
            thumbnailURL: "beijing_food",
            videoURL: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", // Placeholder — replace with actual Chinese vlog
            duration: 185,
            language: .chinese,
            level: .beginner,
            dialogues: sampleDialogues,
            isFeatured: true,
            dateAdded: Date()
        ),
        Video(
            id: UUID(),
            title: "上海一日游 Vlog",
            description: "A day in Shanghai — from the Bund to the Old Town. Great for travel vocabulary and directions.",
            thumbnailURL: "shanghai_vlog",
            videoURL: "https://www.youtube.com/watch?v=placeholder2",
            duration: 243,
            language: .chinese,
            level: .beginner,
            dialogues: [],
            isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        ),
        Video(
            id: UUID(),
            title: "中国大学生的一天",
            description: "A Chinese college student shares their daily routine. Natural, casual Mandarin at a comfortable speed.",
            thumbnailURL: "college_life",
            videoURL: "https://www.youtube.com/watch?v=placeholder3",
            duration: 312,
            language: .chinese,
            level: .elementary,
            dialogues: [],
            isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        ),
        Video(
            id: UUID(),
            title: "和朋友去火锅店",
            description: "Friends hanging out at a hotpot restaurant. Lots of slang, jokes, and real conversational Mandarin.",
            thumbnailURL: "hotpot",
            videoURL: "https://www.youtube.com/watch?v=placeholder4",
            duration: 428,
            language: .chinese,
            level: .intermediate,
            dialogues: [],
            isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        ),
        Video(
            id: UUID(),
            title: "深圳科技公司面试",
            description: "A mock tech interview in Mandarin. Formal vocabulary and professional expressions.",
            thumbnailURL: "tech_interview",
            videoURL: "https://www.youtube.com/watch?v=placeholder5",
            duration: 540,
            language: .chinese,
            level: .advanced,
            dialogues: [],
            isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        ),
        Video(
            id: UUID(),
            title: "故宫历史讲解",
            description: "A guided tour of the Forbidden City. Rich historical vocabulary and formal narration style.",
            thumbnailURL: "forbidden_city",
            videoURL: "https://www.youtube.com/watch?v=placeholder6",
            duration: 390,
            language: .chinese,
            level: .advanced,
            dialogues: [],
            isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -20, to: Date())!
        ),
    ]

    /// Only featured videos (for MainView)
    static var featuredVideos: [Video] {
        videos.filter { $0.isFeatured }
    }

    /// Filter by proficiency level (for VideoBrowsingView)
    static func videos(for level: ProficiencyLevel?) -> [Video] {
        guard let level else { return videos }
        return videos.filter { $0.level == level }
    }
}
