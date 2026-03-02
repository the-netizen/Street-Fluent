import SwiftUI

struct AppTabView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        TabView {
            NavigationStack {
                MainView(selectedDate: selectedDate)
            }
            .tabItem {
                Label("", systemImage: "house.fill")
            }

            NavigationStack {
                VideoBrowsing()
            }
            .tabItem {
                Label("", systemImage: "play.rectangle.fill")
            }

            NavigationStack {
                Practice()
            }
            .tabItem {
                Label("", systemImage: "character.book.closed.fill")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tabViewStyle(.automatic)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    AppTabView()
}
