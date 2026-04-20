import SwiftUI

struct FeaturedVideos: View {
    let featuredVideos: [Video] = SampleData.featuredVideos
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
        .background(.jeans.opacity(0.5))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(.systemBackground), lineWidth: 1)
            )
            .padding(20)
            .sheet(item: $selectedVideo) { video in
                VideoDescriptionSheet(video: video, startStreaming: $navigateToStreaming)
                    .presentationDetents([.medium, .large]) //allow dynamic sizes
                    .onDisappear {
                        if navigateToStreaming {
                            videoToStream = video //save video before sheet dismisses
                        }
                    }
            }
            .navigationDestination(isPresented: $navigateToStreaming) {
                if let video = videoToStream {
                   VideoStreaming(video: video)
               }
            }
    }//body
}//view
    #Preview {
        FeaturedVideos()
    }
