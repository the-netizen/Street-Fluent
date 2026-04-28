import SwiftUI
import SwiftData

@main
struct StreetFluentApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [
            BookmarkedWords.self,
            StudyRecord.self,
            VideoSession.self
        ]) //creates DB on first launch to save these records.
        // this way, all chld views have access to DB
    }
}

