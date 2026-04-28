import SwiftUI

struct FeaturedVideos: View {
    private var settings = AppSettings.shared
    var featuredVideos: [Video] {
        SampleData.videos
            .filter { $0.isFeatured && $0.language == settings.selectedLanguage }
    }
//    let featuredVideos: [Video] = SampleData.featuredVideos
    @State private var selectedVideo: Video? = nil
    @State private var videoToStream: Video? = nil
    @State private var navigateToStreaming = false
    
    var body: some View {
        VStack(spacing: .none){
                HStack{
                    Text("Featured videos")
                        .font(.headline)
                    
                    Spacer()
                    
                    NavigationLink(destination: VideoBrowsing()) {
                        HStack(spacing: 4) {
                            Text("More")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                }//header
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(featuredVideos) { video in
                            VideoCard(video: video)
                                .onTapGesture {
                                    selectedVideo = video
                                }
                        }
                    }
                    .padding(.horizontal)
                }//hscroll
                .padding(.vertical, 20)
            }//v
//            .background(.jeans.opacity(0.5))
        .background(.jeans)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(.systemBackground), lineWidth: 1)
            )
            .padding(20)
            .sheet(item: $selectedVideo) { video in
                VideoDescriptionSheet(video: video, startStreaming: $navigateToStreaming, videoToStream: $videoToStream)
                    .presentationDetents([.medium, .large]) //allow dynamic sizes
            }
            .navigationDestination(isPresented: $navigateToStreaming) {
                if let video = videoToStream {
                   VideoStreaming(video: video)
                       .id(video.id) // create fresh view for each video id changes
               }
            }
    }//body
}//view
    #Preview {
        FeaturedVideos()
    }
