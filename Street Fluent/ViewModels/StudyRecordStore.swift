import Foundation

@Observable
class StudyRecordStore{
    static let shared = StudyRecordStore() // one instance used everywhere
    
    private let key = "studyRecords"
    
    // In-memory records, loaded once at launch
    var records: [StudyRecordStore] = []
    
    private init() {
        load()
    }
    
    // Save a completed video session to today's record
    func saveSession(_ session: VideoSession) {
        let today = Date()
        let calendar = Calendar.current
        
        // Find today's record or create a new one
        if let index = records.firstIndex(where: {
            calendar.isDate($0.date, inSameDayAs: today)
        }) {
            records[index].sessions.append(session)
        } else {
            let newRecord = StudyRecord(id: UUID(), date: today, sessions: [session])
            records.append(newRecord)
        }
        
        save()
    }
    
    func record(for date: Date) -> StudyRecord? {
        let calendar = Calendar.current
        return records.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    // MARK: - Private persistence
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([StudyRecord].self, from: data)
        else {
            records = [] // first launch, no data yet
            return
        }
        records = decoded
    }
}
