import SwiftUI
import SwiftData

struct FlashcardView: View {
    
    @Query(sort: \BookmarkedWords.dateBookmarked, order: .reverse)
    private var allWordsForFiltering: [BookmarkedWords]
    
    private var dueWords: [BookmarkedWords] {
        allWordsForFiltering.filter { $0.nextReviewDate <= Date() }
    }
    
    @Query private var allBookmarks: [BookmarkedWords]
    
    @State private var dragOffset: CGSize = .zero
    
    // Local session queue — drives what the user sees
    // Filled from dueWords, loops through allBookmarks when empty
    @State private var sessionQueue: [BookmarkedWords] = []
    
    var body: some View {
        VStack(spacing: 12) {
            header
            
            if sessionQueue.isEmpty && allBookmarks.isEmpty {
                // Truly nothing bookmarked yet
                noBookmarksState
            } else {
                cardStack
            }
        }
        .padding(16)
        .background(Color.jeans)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemBackground), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        // Fill queue when view appears or dueWords changes
        .onAppear { refillQueueIfNeeded() }
        .onChange(of: dueWords.count) { refillQueueIfNeeded() }
    }
    
    
    private func refillQueueIfNeeded() {
        guard sessionQueue.isEmpty else { return }
        
        if !dueWords.isEmpty {
            // Prefer due words first
            sessionQueue = dueWords
        } else if !allBookmarks.isEmpty {
            //loop..no shuffleee
            sessionQueue = allBookmarks.shuffled()
        }
    }
    
    
    private var header: some View {
        HStack {
            Text("Vocabulary")
                .font(.headline)
            Spacer()
            Text("\(reviewedToday)/\(allBookmarks.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
//            if SampleData.currentStreak > 0 {
//                Label("\(SampleData.currentStreak)", systemImage: "flame.fill")
//                    .font(.caption)
//                    .foregroundStyle(.tangerine)
//            }
        }
    }
        
    private var cardStack: some View {
        ZStack {
            ForEach(Array(sessionQueue.prefix(3).enumerated().reversed()), id: \.element.wordId) { index, word in
                FlashCard(word: word)
                    .offset(y: CGFloat(index) * -6)
                    .scaleEffect(1 - CGFloat(index) * 0.03)
                    .opacity(index == 0 ? 1 : 0.7)
                    .offset(index == 0 ? dragOffset : .zero)
                    .rotationEffect(index == 0 ? .degrees(Double(dragOffset.width) / 20) : .zero)
                    .gesture(index == 0 ? swipeGesture(for: word) : nil)
                    .zIndex(Double(3 - index))
            }
        }
        .frame(height: 260)
        .overlay(alignment: .leading) {
            swipeHint(text: "Forgot", color: .red, opacity: leftHintOpacity)
        }
        .overlay(alignment: .trailing) {
            swipeHint(text: "Known", color: .green, opacity: rightHintOpacity)
        }
        .animation(.spring(response: 0.3), value: dragOffset)
    }
        
    private func swipeGesture(for word: BookmarkedWords) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = CGSize(width: value.translation.width, height: value.translation.height * 0.3)
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                if value.translation.width > threshold {
                    commitSwipe(direction: .right, word: word)
                } else if value.translation.width < -threshold {
                    commitSwipe(direction: .left, word: word)
                } else {
                    dragOffset = .zero
                }
            }
    }
    
    private func commitSwipe(direction: SwipeDirection, word: BookmarkedWords) {
        withAnimation(.easeOut(duration: 0.2)) {
            dragOffset = CGSize(width: direction == .right ? 500 : -500, height: 0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            // Update SRS state
            switch direction {
            case .right: word.markKnown()
            case .left:  word.markLearning()
            }
            
            // Remove from front of queue
            if !sessionQueue.isEmpty {
                sessionQueue.removeFirst()
            }
            
            // If queue is now empty, refill and loop
            refillQueueIfNeeded()
            
            dragOffset = .zero
        }
    }
    
    
    private func swipeHint(text: String, color: Color, opacity: Double) -> some View {
        Text(text)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(color)
            .padding(8)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 16)
            .opacity(opacity)
    }
    
    private var leftHintOpacity: Double {
        Double(max(0, -dragOffset.width - 20)) / 80
    }
    
    private var rightHintOpacity: Double {
        Double(max(0, dragOffset.width - 20)) / 80
    }
    
    private var reviewedToday: Int {
        let calendar = Calendar.current
        return allBookmarks.filter {
            guard let last = $0.lastReviewDate else { return false }
            return calendar.isDateInToday(last)
        }.count
    }
    
    //no bookmarks
    private var noBookmarksState: some View {
        VStack(spacing: 8) {
            Image(systemName: "bookmark")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No bookmarks yet")
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    private enum SwipeDirection { case left, right }
}


struct FlashCard: View {
    let word: BookmarkedWords
    @State private var isFlipped = false  // front = character, back = definition
    
    var body: some View {
        ZStack {
            if !isFlipped {
                // Front — character + pinyin
                front
            } else {
                // Back — definitions
                back
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onTapGesture {
            // Tap card to flip and reveal definitions
            withAnimation(.spring(response: 0.4)) {
                isFlipped.toggle()
            }
        }
        // Reset flip when card changes
        .onChange(of: word.wordId) {
            isFlipped = false
        }
    }
    
    private var front: some View {
        VStack(spacing: 12) {
//            Text(word.pinyin)
//                .font(.title3)
//                .foregroundStyle(.secondary)
            Text(word.word)
                .font(.system(size: 72, weight: .medium))
                .foregroundStyle(.primary)
            Text("tap to reveal")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }
    
    private var back: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(word.pinyin)
            .font(.title3)
            .foregroundStyle(.secondary)
            
            Text(word.word)
                .font(.system(size: 72, weight: .medium))
                .foregroundStyle(.primary)
            
            ScrollView {
                HStack( spacing: 6) {
                    ForEach(word.definitions, id: \.self) { def in
                        Text("• \(def)")
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }
//                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    // In-memory container with sample bookmarks for canvas testing
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BookmarkedWords.self, configurations: config)
    
    // Insert sample words so preview isn't empty
    let samples = [
        ("zh_ni3hao3", "你好", "nǐ hǎo", ["hello", "hi"]),
        ("zh_pisa4",   "披萨", "pī sà",  ["pizza"]),
        ("zh_sheng1",  "生",   "shēng",  ["to grow", "to live", "to arise"])
    ]
    for (id, word, pinyin, defs) in samples {
        let vocab = Vocabulary(id: id, word: word, pinyin: pinyin, definitions: defs, level: .beginner)
        let bookmark = BookmarkedWords(from: vocab)
        container.mainContext.insert(bookmark)
    }
    
    return FlashcardView()
        .modelContainer(container)
}
