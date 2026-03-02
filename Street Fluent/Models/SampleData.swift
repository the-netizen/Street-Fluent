import Foundation

enum SampleData {
   
    static let messageDialogue: [Dialogue] = [
        Dialogue(
            id: UUID(), index: 0,
            startTime: 0.0, endTime: 2.8,
            originalText: "大家 好",
            translatedText: "Hello everyone",
            words: [
                Vocabulary(id: UUID(), word: "大家", pinyin: "dàjiā", meaning: "everyone", level: .beginner),
                Vocabulary(id: UUID(), word: "好", pinyin: "hǎo", meaning: "good; hello", level: .beginner),
            ]
        ),
        Dialogue(
            id: UUID(), index: 1,
            startTime: 2.8, endTime: 5.5,
            originalText: "欢迎 来到 我的 频道",
            translatedText: "Welcome to my channel",
            words: [
                Vocabulary(id: UUID(), word: "欢迎", pinyin: "huānyíng", meaning: "welcome", level: .beginner),
                Vocabulary(id: UUID(), word: "来到", pinyin: "láidào", meaning: "to arrive", level: .beginner),
                Vocabulary(id: UUID(), word: "我的", pinyin: "wǒ de", meaning: "my", level: .beginner),
                Vocabulary(id: UUID(), word: "频道", pinyin: "píndào", meaning: "channel", level: .elementary),
            ]
        ),
        Dialogue(
            id: UUID(), index: 2,
            startTime: 5.5, endTime: 9.0,
            originalText: "今天 我 带 你们 去 吃 北京 烤鸭",
            translatedText: "Today I'll take you to eat Beijing roast duck",
            words: [
                Vocabulary(id: UUID(), word: "今天", pinyin: "jīntiān", meaning: "today", level: .beginner),
                Vocabulary(id: UUID(), word: "我", pinyin: "wǒ", meaning: "I", level: .beginner),
                Vocabulary(id: UUID(), word: "带", pinyin: "dài", meaning: "to take; bring", level: .beginner),
                Vocabulary(id: UUID(), word: "你们", pinyin: "nǐmen", meaning: "you (plural)", level: .beginner),
                Vocabulary(id: UUID(), word: "去", pinyin: "qù", meaning: "to go", level: .beginner),
                Vocabulary(id: UUID(), word: "吃", pinyin: "chī", meaning: "to eat", level: .beginner),
                Vocabulary(id: UUID(), word: "北京", pinyin: "Běijīng", meaning: "Beijing", level: .beginner),
                Vocabulary(id: UUID(), word: "烤鸭", pinyin: "kǎoyā", meaning: "roast duck", level: .elementary),
            ]
        ),
        Dialogue(
            id: UUID(), index: 3,
            startTime: 9.0, endTime: 12.5,
            originalText: "这家 店 非常 有名",
            translatedText: "This restaurant is very famous",
            words: [
                Vocabulary(id: UUID(), word: "这家", pinyin: "zhè jiā", meaning: "this (shop/restaurant)", level: .beginner),
                Vocabulary(id: UUID(), word: "店", pinyin: "diàn", meaning: "shop; store", level: .beginner),
                Vocabulary(id: UUID(), word: "非常", pinyin: "fēicháng", meaning: "very; extremely", level: .beginner),
                Vocabulary(id: UUID(), word: "有名", pinyin: "yǒumíng", meaning: "famous", level: .beginner),
            ]
        ),
    ]
    
    // MARK: - Dialogues for Video 2 (Daily Routine)
    
    static let poemDialogue: [Dialogue] = [
        Dialogue(
            id: UUID(), index: 0,
            startTime: 0.0, endTime: 3.0,
            originalText: "早上 好 朋友们",
            translatedText: "Good morning friends",
            words: [
                Vocabulary(id: UUID(), word: "早上", pinyin: "zǎoshang", meaning: "morning", level: .beginner),
                Vocabulary(id: UUID(), word: "好", pinyin: "hǎo", meaning: "good", level: .beginner),
                Vocabulary(id: UUID(), word: "朋友们", pinyin: "péngyǒumen", meaning: "friends", level: .beginner),
            ]
        ),
        Dialogue(
            id: UUID(), index: 1,
            startTime: 3.0, endTime: 6.2,
            originalText: "现在 是 早上 七点",
            translatedText: "It's 7 AM now",
            words: [
                Vocabulary(id: UUID(), word: "现在", pinyin: "xiànzài", meaning: "now", level: .beginner),
                Vocabulary(id: UUID(), word: "是", pinyin: "shì", meaning: "is; to be", level: .beginner),
                Vocabulary(id: UUID(), word: "早上", pinyin: "zǎoshang", meaning: "morning", level: .beginner),
                Vocabulary(id: UUID(), word: "七点", pinyin: "qī diǎn", meaning: "7 o'clock", level: .beginner),
            ]
        ),
        Dialogue(
            id: UUID(), index: 2,
            startTime: 6.2, endTime: 10.0,
            originalText: "我 先 去 刷牙 洗脸",
            translatedText: "First I'll go brush my teeth and wash my face",
            words: [
                Vocabulary(id: UUID(), word: "我", pinyin: "wǒ", meaning: "I", level: .beginner),
                Vocabulary(id: UUID(), word: "先", pinyin: "xiān", meaning: "first", level: .beginner),
                Vocabulary(id: UUID(), word: "去", pinyin: "qù", meaning: "to go", level: .beginner),
                Vocabulary(id: UUID(), word: "刷牙", pinyin: "shuāyá", meaning: "brush teeth", level: .elementary),
                Vocabulary(id: UUID(), word: "洗脸", pinyin: "xǐliǎn", meaning: "wash face", level: .elementary),
            ]
        ),
    ]
    
    // MARK: - All Videos
    // videoURL uses local bundle file names. Add your .mp4 files to Xcode project.
    // For videos without local files, videoURL is empty — they'll show in browsing but can't stream yet.
    
    static let videos: [Video] = [
        // === FEATURED (shown on home) ===
        Video(
            id: UUID(), title: "新年快乐",
            description: "Message to a friend for new years.",
            thumbnailURL: "Sample-video-1.jpg.avif", videoURL: "Sample-video-1.mov",
            duration: 19, language: .chinese, level: .beginner,
            dialogues: messageDialogue,
            isFeatured: true, dateAdded: Date()
        ),
        Video(
            id: UUID(), title: "poem",
            description: "A Chinese poem", thumbnailURL: "Sample-video-2.jpg", videoURL: "Sample-video-2.mov",
            duration: 16, language: .chinese, level: .beginner,
            dialogues: poemDialogue,
            isFeatured: true, dateAdded: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        ),
        Video(
            id: UUID(), title: "上海一日游 Vlog",
            description: "A day in Shanghai — from the Bund to the Old Town. Great for travel vocabulary.",
            thumbnailURL: "shanghai_vlog", videoURL: "",
            duration: 243, language: .chinese, level: .beginner,
            dialogues: [], isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        ),
        
        // === HSK 2 / Elementary ===
        Video(
            id: UUID(), title: "和朋友去超市",
            description: "Going to the supermarket with friends. Learn shopping vocabulary and measure words.",
            thumbnailURL: "supermarket", videoURL: "",
            duration: 198, language: .chinese, level: .elementary,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        ),
        Video(
            id: UUID(), title: "坐地铁去学校",
            description: "Taking the subway to school. Directions, transportation words, and casual speech.",
            thumbnailURL: "subway", videoURL: "",
            duration: 167, language: .chinese, level: .elementary,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        ),
        
        // === HSK 3 / Intermediate ===
        Video(
            id: UUID(), title: "和朋友去火锅店",
            description: "Friends at a hotpot restaurant. Slang, jokes, and real conversational Mandarin.",
            thumbnailURL: "hotpot", videoURL: "",
            duration: 428, language: .chinese, level: .intermediate,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -12, to: Date())!
        ),
        Video(
            id: UUID(), title: "租房子的经历",
            description: "Apartment hunting in China. Useful vocabulary for housing, contracts, and negotiation.",
            thumbnailURL: "apartment", videoURL: "",
            duration: 315, language: .chinese, level: .intermediate,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -15, to: Date())!
        ),
        
        // === HSK 4 / Advanced ===
        Video(
            id: UUID(), title: "深圳科技公司面试",
            description: "A mock tech interview in Mandarin. Formal vocabulary and professional expressions.",
            thumbnailURL: "tech_interview", videoURL: "",
            duration: 540, language: .chinese, level: .advanced,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -18, to: Date())!
        ),
        Video(
            id: UUID(), title: "故宫历史讲解",
            description: "Guided tour of the Forbidden City. Rich historical vocabulary and formal narration.",
            thumbnailURL: "forbidden_city", videoURL: "",
            duration: 390, language: .chinese, level: .advanced,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -22, to: Date())!
        ),
    ]
    
    static var featuredVideos: [Video] {
        videos.filter { $0.isFeatured }
    }
    
    static func videos(for level: ProficiencyLevel?) -> [Video] {
        guard let level else { return videos }
        return videos.filter { $0.level == level }
    }
    
//    static func videoCount(for level: ProficiencyLevel) -> Int {
//    videos.filter { $0.level == level }.count
//}
    static let studyRecords: [StudyRecord] = {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            StudyRecord(id: UUID(), date: today,
                        minutesStudied: 25, wordsReviewed: 12, wordsLearned: 4, videosWatched: 2),
            StudyRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -1, to: today)!,
                        minutesStudied: 15, wordsReviewed: 8, wordsLearned: 2, videosWatched: 1),
            StudyRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -2, to: today)!,
                        minutesStudied: 30, wordsReviewed: 20, wordsLearned: 5, videosWatched: 3), //start streak
            StudyRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -3, to: today)!,
                        minutesStudied: 0, wordsReviewed: 0, wordsLearned: 0, videosWatched: 0),
            StudyRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -4, to: today)!,
                        minutesStudied: 20, wordsReviewed: 15, wordsLearned: 3, videosWatched: 2),
            StudyRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -5, to: today)!,
                        minutesStudied: 10, wordsReviewed: 5, wordsLearned: 1, videosWatched: 1),
            StudyRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -6, to: today)!,
                        minutesStudied: 35, wordsReviewed: 22, wordsLearned: 6, videosWatched: 2),
        ]
    }()
    
    //find study record for specific date
    static func studyRecord(for date: Date) -> StudyRecord? {
        let calendar = Calendar.current
        return studyRecords.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    static var currentStreak: Int {
        let calendar = Calendar.current
        let sorted = studyRecords
            .filter { $0.didStudy }
            .sorted { $0.date > $1.date }  //sort in descending
        
        guard let first = sorted.first else { return 0 }
        
        //start from today or yesterday
        let today = Date()
        let isToday = calendar.isDate(first.date, inSameDayAs: today)
        let isYesterday = calendar.isDate(first.date, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today)!)
        guard isToday || isYesterday else { return 0 }
        
        var streak = 1
        for i in 1..<sorted.count {
            let expected = calendar.date(byAdding: .day, value: -i, to: first.date)!
            if calendar.isDate(sorted[i].date, inSameDayAs: expected) {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }

}
