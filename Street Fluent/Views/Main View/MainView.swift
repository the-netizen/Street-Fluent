import SwiftUI

struct MainView: View {
    @State var selectedDate: Date
//    private var settings = AppSettings.shared

    // Explicit initializer
    init(selectedDate: Date) {
        _selectedDate = State(initialValue: selectedDate)
    }

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 15){
                    Spacer()
                    
                    //WeeklyCalenderView
                    WeeklyCalendarView(selectedDate: $selectedDate)
                    
                    //Vocabulary flashcards
                    
                    // FeaturedVideos
//                    FeaturedVideos()
                    VideoBrowsing()
                    
                    // maybe a graph idk.
                    
                    // FeaturedArticles in future:
                    //                    FeaturedVideos()
                    
                    Spacer()
                    
                }
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    MainView(selectedDate: Date())
}
