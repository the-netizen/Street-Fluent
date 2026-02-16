import SwiftUI

struct VideoBrowsing: View {
    @State private var selectedLevel: ProficiencyLevel? = nil
    @Environment(\.dismiss) private var dismiss
    
    var filteredVideos: [Video] {
        SampleData.videos(for: selectedLevel)
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //filtering at top
                FilterView(selectedLevel: $selectedLevel)
                    .padding(.horizontal)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredVideos) { video in
                        NavigationLink(destination: VideoDescription(video: video)) {
                            VideoCard(video: video, style: .grid, showLevelBadge: selectedLevel == nil)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 20)
        }
        .background(Color.mute)
        .navigationTitle("Content")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct FilterView: View {
    @Binding var selectedLevel: ProficiencyLevel?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterOption(
                    title: "All",
//                    count: SampleData.videos.count,
                    isSelected: selectedLevel == nil
                ) {
                    selectedLevel = nil
                }

                // Level buttons
                ForEach(ProficiencyLevel.allCases) { level in
                    FilterOption(
                        title: level.displayName,
//                        count: SampleData.videoCount(for: level),
                        isSelected: selectedLevel == level
                    ) {
                        selectedLevel = level
                    }
                }
            }
        }
    }
}

struct FilterOption: View {
    let title: String
//    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack{
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                
//                Text("\(count)")
//                    .font(.caption)
//                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.tangerine : Color.road.opacity(0.4))
            .foregroundColor(.primary)
            .cornerRadius(20)
        }
    }
}

#Preview {
    NavigationStack {
        VideoBrowsing()
    }
}
