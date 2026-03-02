import SwiftUI

struct WeeklyCalendarView: View {
    @Binding var selectedDate: Date
    @State private var weekOffset: Int = 0  // 0 = current, -1 = last week
    
    private let calendar = Calendar.current
    private var weekDays: [Date] {
        // Get start of the week
        let referenceDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: Date())!
        //first day of week
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: referenceDate)!.start
        
        //array of 7 days
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    private var monthYearLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: weekDays[3]) //find month from mid of week
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            WeekHeader(
                label: monthYearLabel,
                weekOffset: $weekOffset
            )
            .padding(.bottom, 10)
            
            // Weekdays
            WeekDaysRow(
                weekDays: weekDays,
                selectedDate: $selectedDate,
                calendar: calendar
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.clear)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}

struct WeekHeader: View {
    let label: String
    @Binding var weekOffset: Int
    
    var body: some View {
        HStack {
            Button {
                weekOffset -= 1 // go to previous week
            } label: {
                Image(systemName: "chevron.left")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                weekOffset += 1 // go to next week
            } label: {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .disabled(weekOffset >= 0) // cant go to future
            .foregroundStyle(weekOffset >= 0 ? .gray : .primary) //disabled btn is gray
        }
        .foregroundStyle(.primary)
    }
}

struct WeekDaysRow: View {
    let weekDays: [Date]
    @Binding var selectedDate: Date
    let calendar: Calendar
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekDays, id: \.self) { day in
                DayCell(
                    date: day,
                    isSelected: calendar.isDate(day, inSameDayAs: selectedDate),
                    isToday: calendar.isDateInToday(day),
                    didStudy: SampleData.studyRecord(for: day)?.didStudy ?? false
                )
                .onTapGesture {
                    selectedDate = day
                }
                
                if day != weekDays.last {
                    Spacer()
                }
            }
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let didStudy: Bool
    
    private let calendar = Calendar.current
    
    private var dayLetter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"  // Single letter
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        "\(calendar.component(.day, from: date))"
    }
    
    private var isFuture: Bool {
        date > Date()
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // day name
            Text(dayLetter)
                .font(.caption2)
                .foregroundStyle(isFuture ? .gray : .secondary)
            
            // day number
            ZStack {
                Circle()
                    .fill(isSelected ? Color.tangerine : (didStudy ? Color.sage : Color.clear))
                    .stroke(Color.primary, lineWidth: 1.5)
                    .frame(width: 34, height: 34)
                
                // Today ring (when not selected)
                if isToday && !isSelected {
                    Circle()
                        .stroke(Color.primary.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 34, height: 34)
                }
                
                Text(dayNumber)
                    .font(.subheadline)
                    .fontWeight(isToday ? .bold : .regular)
                    .foregroundStyle(
                        isSelected ? .white : .primary,
                        isFuture ? .black : .primary
                    )
            }
            
            // Study activity dot
//            Circle()
//                .fill(didStudy ? Color.green : Color.clear)
//                .frame(width: 5, height: 5)
        }
        .opacity(isFuture ? 0.5 : 1)
    }
}

#Preview {
    WeeklyCalendarView(selectedDate: .constant(Date()))
        .padding()
}
