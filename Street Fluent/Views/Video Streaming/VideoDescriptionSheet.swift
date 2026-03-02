import SwiftUI

struct VideoDescriptionSheet: View {
    let video: Video
    @Binding var startStreaming: Bool  // tells parent to open VideoStreaming
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text(video.title)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                // number of new words
                Text(video.level.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    ZStack {
                        //fixed thumbnail size
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 80)
                        
                        HStack(alignment: .top) {
                            //video thumbnail
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.tertiarySystemGroupedBackground))
                                .frame(width: 100, height: 70)
                                .overlay {
                                    Image(systemName: "play.fill") //video thumbnail
                                        .foregroundStyle(.gray.opacity(0.4))
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.primary, lineWidth: 1)
                                }
                            
                            Spacer().frame(width: 20)
                            
                            // Description text area
                            Text(video.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .lineLimit(3)
                        }
                    }// description area
                    .frame(maxWidth: .infinity)
                    .padding(12)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 10)
                    .background(Color(.systemBackground).opacity(0.2))
                    .cornerRadius(12)
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    }
                    
                    if !video.dialogues.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Transcript")
                                .font(.headline)
                                .padding(.bottom, 20)
                            
                            ForEach(video.dialogues) { dialogue in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(dialogue.originalText)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    Text(dialogue.translatedText)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground).opacity(0.5))
                        .cornerRadius(12)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary, lineWidth: 1)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
            
            // MARK: - Start Button (fixed bottom)
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                        startStreaming = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("开始")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.tangerine)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            .background(.ultraThinMaterial)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.primary),
                alignment: .top
            ) //line border
        }
        .background(Color.sage.opacity(0.7))
    }
}

#Preview {
    VideoDescriptionSheet(video: SampleData.videos[0], startStreaming: .constant(true))
}
