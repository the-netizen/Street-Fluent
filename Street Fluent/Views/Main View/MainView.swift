import SwiftUI

struct MainView: View {
    @State var selectedDate: Date = Date()
    private var settings = AppSettings.shared //shared app settings to store user pref

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
                    
                    Spacer()
                }
            }
            .background(Color(.systemBackground))
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    LanguagePickerButton(settings: settings)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ProfileButton()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
