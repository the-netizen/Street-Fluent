import SwiftUI
import SwiftData

struct DictionaryPopup: View {
    let word: Vocabulary
    var onDismiss: () -> Void
    
    // to save word to disk, we need model context
    @Environment(\.modelContext) private var modelContext
        
    // check if already bookmarked to toggle icon
    @Query private var allBookmarks: [BookmarkedWords]
    private var isBookmarked: Bool {
        allBookmarks.contains { $0.wordId == word.id }
    }
    
    var body: some View {
        HStack(spacing: 0){
            // char
            VStack{
                Text(word.word)
                    .font(.title3)
                    .foregroundStyle(.primary)
                Text(word.pinyin ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
//            .frame(maxWidth: .infinity)
            .frame(width: 80)
//            .padding(.vertical, 8)
            
            Rectangle()
               .fill(Color.primary.opacity(0.15))
               .frame(width: 1)
               .padding(.vertical, 8)
            
            // dictionary scroll
            ScrollView{
                VStack(alignment: .leading, spacing: 2){
                    ForEach(word.definitions, id: \.self) {definition in
                        Text(definition)
                            .font(.caption2)
                            .foregroundStyle(.primary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .frame(maxHeight: 70) //will scroll outside this
            
            Rectangle()
               .fill(Color.primary.opacity(0.15))
               .frame(width: 1)
               .padding(.vertical, 8)
            
            // bookmark
            Button {
                toggleBookmark()
            } label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            .frame(width: 50)

        }//h
        .background(Color.sage)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary, lineWidth: 2)
        )//border
        .padding(.horizontal, 8)
        .frame(width: 300)

    }
    private func toggleBookmark() {
        if let existing = allBookmarks.first(where: { $0.wordId == word.id }) {
            // Already bookmarked → remove it
            modelContext.delete(existing)
        } else {
            // Not bookmarked → save it
            let bookmark = BookmarkedWords(from: word)
            modelContext.insert(bookmark)
        }
        // SwiftData saves automatically
    }
}

#Preview {
    DictionaryPopup(
        word: Vocabulary(
        id: "zh_sheng1",
        word: "生",
        pinyin: "shēng",
        definitions: ["to grow", "to live", "to arise"],
        level: .beginner
        ),
        onDismiss: {}
    )
}
