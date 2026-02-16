import SwiftUI

struct MainView: View {
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Spacer(minLength: 200)
                    
                    //calenderView to view Streak/  srs
                
                    // FeaturedVideos
                    FeaturedVideos()
                    
                    // FeaturedArticles in future:
                    FeaturedVideos()
                    
                    Spacer()
                                        
                }
            }
            .background(Color.mute)
        }
//        .navigationTitle("Street Fluent")
    }
}

#Preview {
    MainView()
}
