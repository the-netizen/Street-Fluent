import SwiftUI

struct FeaturedVideos: View {
    let featuredVideos: [Video] = SampleData.featuredVideos
    
    var body: some View {
            VStack(spacing: .none){
                HStack{
                    Text("Featured")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    Spacer()
                    NavigationLink(destination: VideoBrowsing()){
                        Text("More")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.white)
                }//h
                .padding(.horizontal, 20)
                .padding(.vertical, 20)

                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(featuredVideos) { video in
                            NavigationLink(destination: VideoDescription(video: video)){
                                VideoCard(video: video)}
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }//hscroll
                .padding(.vertical, 20)
            }//v
            .background(.jeans.opacity(0.7))
            .border(Color.black, width: 2)
            .cornerRadius(25)
            .padding(20)
    }//body
}//view
    #Preview {
        FeaturedVideos()
    }
