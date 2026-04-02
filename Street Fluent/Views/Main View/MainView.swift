import SwiftUI

struct MainView: View {
    @State var selectedDate: Date
    
    var body: some View {
//        NavigationStack{
            ScrollView{
                VStack(spacing: 15){
                    Spacer()
                    
                    //WeeklyCalenderView
                    WeeklyCalendarView(selectedDate: $selectedDate)
                    
                    //SRSView
                    DailyProgressCard(selectedDate: selectedDate)
                    
                    // FeaturedVideos
                    FeaturedVideos()
                    
                    // maybe a graph idk.
                    
                    // FeaturedArticles in future:
//                    FeaturedVideos()
                    
                    Spacer()
                                        
                }
            }
            .background(Color.bg)
        }
//        .navigationTitle("Street Fluent")
//    }
}

#Preview {
    MainView(selectedDate: Date())
}
