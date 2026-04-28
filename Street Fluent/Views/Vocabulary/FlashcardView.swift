import SwiftUI
import SwiftData

struct Flashcards: View {
    
    // Current date for comparison - captured once when view is created
    private let currentDate = Date()
    
    // Live query — only words due for review today or earlier
    // Sorted so newest bookmarks appear first
    @Query(sort: \BookmarkedWords.dateBookmarked, order: .reverse)
    private var allDueWords: [BookmarkedWords]
    
    // All bookmarks for the total count in header
    @Query private var allBookmarks: [BookmarkedWords]
    
    // Filter due words in a computed property instead of in the query
    private var dueWords: [BookmarkedWords] {
        allDueWords.filter { $0.nextReviewDate <= currentDate }
    }
    
    // Tracks drag offset of the top card
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 12) {
            header
            
            if dueWords.isEmpty {
                emptyState
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
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Text("Vocabulary")
                .font(.headline)
            
            Spacer()
            
            // reviewed today / total bookmarked
            Text("\(reviewedToday)/\(allBookmarks.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Streak — reuse SampleData.currentStreak for now
            // will wire to real SwiftData streak later
//            if SampleData.currentStreak > 0 {
//                Label("\(SampleData.currentStreak)", systemImage: "flame.fill")
//                    .font(.caption)
//                    .foregroundStyle(.tangerine)
//            }
        }
    }
    
    // MARK: - Card Stack
    
    private var cardStack: some View {
        ZStack {
            // Show up to 3 stacked cards behind for depth effect
            // They're slightly offset to look like a stack
            ForEach(Array(dueWords.prefix(3).enumerated().reversed()), id: \.offset) { index, word in
                FlashCard(word: word)
                    .offset(y: CGFloat(index) * -6)  // stack offset
                    .scaleEffect(1 - CGFloat(index) * 0.03) // slightly smaller behind
                    .opacity(index == 0 ? 1 : 0.7)
                    // Only the top card (index 0) is draggable
                    .offset(index == 0 ? dragOffset : .zero)
                    .rotationEffect(index == 0 ? .degrees(Double(dragOffset.width) / 20) : .zero)
                    .gesture(index == 0 ? swipeGesture(for: word) : nil)
                    .zIndex(Double(3 - index)) // top card renders on top
            }
        }
        .frame(height: 260)
        // Swipe hint colours bleed through at edges
        .overlay(alignment: .leading) {
            swipeHint(text: "Again", color: .red, opacity: leftHintOpacity)
        }
        .overlay(alignment: .trailing) {
            swipeHint(text: "Got it", color: .green, opacity: rightHintOpacity)
        }
        .animation(.spring(response: 0.3), value: dragOffset)
    }
    
    // MARK: - Swipe Gesture
    
    private func swipeGesture(for word: BookmarkedWords) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // Only allow horizontal drag
                dragOffset = CGSize(width: value.translation.width, height: value.translation.height * 0.3)
            }
            .onEnded { value in
                let threshold: CGFloat = 100 // how far to drag before committing
                
                if value.translation.width > threshold {
                    // Swiped right — knows it
                    commitSwipe(direction: .right, word: word)
                } else if value.translation.width < -threshold {
                    // Swiped left — still learning
                    commitSwipe(direction: .left, word: word)
                } else {
                    // Not far enough — snap back
                    dragOffset = .zero
                }
            }
    }
    
    private func commitSwipe(direction: SwipeDirection, word: BookmarkedWords) {
        // Fly card off screen in swipe direction
        withAnimation(.easeOut(duration: 0.2)) {
            dragOffset = CGSize(
                width: direction == .right ? 500 : -500,
                height: 0
            )
        }
        
        // Update SRS state after card flies off
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            switch direction {
            case .right: word.markKnown()
            case .left:  word.markLearning()
            }
            // Reset drag for next card
            dragOffset = .zero
        }
    }
    
    // MARK: - Hint overlays
    
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
    
    // Hint fades in as user drags
    private var leftHintOpacity: Double {
        Double(max(0, -dragOffset.width - 20)) / 80
    }
    
    private var rightHintOpacity: Double {
        Double(max(0, dragOffset.width - 20)) / 80
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)
            Text("All caught up!")
                .font(.headline)
            Text("Bookmark words while watching videos to practice them here.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    // Count words reviewed today
    private var reviewedToday: Int {
        let calendar = Calendar.current
        return allBookmarks.filter {
            guard let last = $0.lastReviewDate else { return false }
            return calendar.isDateInToday(last)
        }.count
    }
    
    // Swipe direction helper — local to this view
    private enum SwipeDirection {
        case left, right
    }
}

// MARK: - Individual Flashcard

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
            Text(word.pinyin)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(word.word)
                .font(.system(size: 72, weight: .medium))
                .foregroundStyle(.primary)
            Text("tap to reveal")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }
    
    private var back: some View {
        VStack(spacing: 12) {
            Text(word.word)
                .font(.title2)
                .fontWeight(.medium)
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(word.definitions, id: \.self) { def in
                        Text("• \(def)")
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 20)
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
    
    return Flashcards()
        .modelContainer(container)
}
