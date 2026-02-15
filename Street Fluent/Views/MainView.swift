import SwiftUI

struct MainView: View {
    let featuredVideos: [Video] = SampleData.featuredVideos
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    HStack{
                        // FeaturedVideosView
                    }//h
                }//v
            }//scroll
        }//nav
    }//body
}

#Preview {
    MainView()
}
