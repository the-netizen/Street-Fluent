import Foundation

enum SampleData {
   
   
    static let videos: [Video] = [
        Video(
            id: UUID(), title: "新年快乐",
            description: "Message to a friend for new years.",
            thumbnailURL: "Sample-image-1.avif", videoURL: "Sample-video-1",
            duration: 19, language: .chinese, level: .beginner,
            dialogues: SubtitleLoader.loadDialogues(for: "Sample-video-1"),
            isFeatured: true, dateAdded: Date()
        ),
        Video(
            id: UUID(), title: "poem",
            description: "A Chinese poem",
            thumbnailURL: "Sample-image-2.jpg", videoURL: "Sample-video-2",
            duration: 16, language: .chinese, level: .beginner,
            dialogues: SubtitleLoader.loadDialogues(for: "Sample-video-2"),
            isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        ),
        Video(
            id: UUID(), title: "中国人在吃披萨",
            description: "Trying Saudi pizza for the first time.",
            thumbnailURL: "Sample-image-10.jpeg", videoURL: "Sample-video-3",
            duration: 48, language: .chinese, level: .beginner,
            dialogues: SubtitleLoader.loadDialogues(for: "Sample-video-3"),
            isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        ),
        
        Video(
            id: UUID(), title: "上海一日游 Vlog",
            description: "A day in Shanghai — from the Bund to the Old Town. Great for travel vocabulary.",
            thumbnailURL: "Sample-image-3.png", videoURL: "",
            duration: 243, language: .chinese, level: .beginner,
            dialogues: [], isFeatured: true,
            dateAdded: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        ),
        
        // === HSK 2 / Elementary ===
        Video(
            id: UUID(), title: "和朋友去超市",
            description: "Going to the supermarket with friends. Learn shopping vocabulary and measure words.",
            thumbnailURL: "Sample-image-4.jpeg", videoURL: "",
            duration: 198, language: .chinese, level: .elementary,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -8, to: Date())!
        ),
        Video(
            id: UUID(), title: "坐地铁去学校",
            description: "Taking the subway to school. Directions, transportation words, and casual speech.",
            thumbnailURL: "Sample-image-5.avif", videoURL: "",
            duration: 167, language: .chinese, level: .elementary,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        ),
        
        // === HSK 3 / Intermediate ===
        Video(
            id: UUID(), title: "和朋友去火锅店",
            description: "Friends at a hotpot restaurant. Slang, jokes, and real conversational Mandarin.",
            thumbnailURL: "Sample-image-6.jpg", videoURL: "",
            duration: 428, language: .chinese, level: .intermediate,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -12, to: Date())!
        ),
        Video(
            id: UUID(), title: "租房子的经历",
            description: "Apartment hunting in China. Useful vocabulary for housing, contracts, and negotiation.",
            thumbnailURL: "Sample-image-7.jpg", videoURL: "",
            duration: 315, language: .chinese, level: .intermediate,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -15, to: Date())!
        ),
        
        // === HSK 4 / Advanced ===
        Video(
            id: UUID(), title: "深圳科技公司面试",
            description: "A mock tech interview in Mandarin. Formal vocabulary and professional expressions.",
            thumbnailURL: "Sample-image-8.webp", videoURL: "",
            duration: 540, language: .chinese, level: .advanced,
            dialogues: [], isFeatured: false,
            dateAdded: Calendar.current.date(byAdding: .day, value: -18, to: Date())!
        ),
        Video(
            id: UUID(), title: "故宫历史讲解",
            description: "Guided tour of the Forbidden City. Rich historical vocabulary and formal narration.",
            thumbnailURL: "Sample-image-9.jpeg", videoURL: "",
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
