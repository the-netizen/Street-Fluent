import SwiftUI

struct MainView: View {
    @State var selectedDate: Date
    
    var body: some View {
//        NavigationStack{
            ScrollView{
                VStack(spacing: 15){
                    Spacer()
                    
                    //Logo image
//                    HStack{
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(width: 45, height: 40)
//                                .foregroundColor(.road)
//                                
//                            Text("SF")
//                                .font(.title)
//                                .foregroundColor(.white)
//                        }
//                        Spacer()
//                    }
//                    .padding(.leading, 20)
                        
                    
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
