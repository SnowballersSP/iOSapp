import SwiftUI

struct SelectDayPage: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            // Header Tab
            Text("Select Day")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Month Navigation
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding()
                }
                
                Text(monthYearString)
                    .font(.title2)
                    .frame(width: 200, alignment: .center)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                        .padding()
                }
            }
            
            // Calendar Grid
            CalendarView(selectedDate: $selectedDate)
            
            Spacer()
            
            // Confirm Selection Button
            NavigationLink(destination: ConfirmTimePage(selectedDate: selectedDate)) {
                Text("Confirm Date")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
    
    // Computed property to format month & year
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    // Move to the previous month
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    // Move to the next month
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
}

// Calendar View
struct CalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            // Days of the week
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
            }
            
            // Days of the month
            let days = generateCalendarDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { date in
                    Button(action: {
                        selectedDate = date
                    }) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .frame(width: 40, height: 40)
                            .background(isSameDay(date, selectedDate) ? Color.blue : Color.clear)
                            .foregroundColor(isSameDay(date, selectedDate) ? .white : .black)
                            .cornerRadius(20)
                    }
                }
            }
        }
        .padding()
    }
    
    // Generates the days of the selected month
//    private func generateCalendarDays() -> [Date] {
//        var dates: [Date] = []
//        let calendar = Calendar.current
//        let currentMonth = calendar.component(.month, from: selectedDate)
////        let range = calendar.range(of: .day, in: .month, for: selectedDate) ?? 1...30
////        let range = (calendar.range(of: .day, in: .month, for: selectedDate) ?? 1...30).lowerBound..<(calendar.range(of: .day, in: .month, for: selectedDate)?.upperBound ?? 31)
//        if let range = calendar.range(of: .day, in: .month, for: selectedDate) {
//            for day in range {
//                if let date = calendar.date(from: DateComponents(
//                    year: calendar.component(.year, from: selectedDate),
//                    month: calendar.component(.month, from: selectedDate),
//                    day: day))
//                {
//                    dates.append(date)
//                }
//            }
//        }
//
//        for day in range {
//            if let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDate), month: currentMonth, day: day)) {
//                dates.append(date)
//            }
//        }
//        
//        return dates
//    }
    private func generateCalendarDays() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: selectedDate)
        let currentYear = calendar.component(.year, from: selectedDate)

        // Safely unwrap the range of days in the selected month
        if let dayRange = calendar.range(of: .day, in: .month, for: selectedDate) {
            for day in dayRange {
                if let date = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: day)) {
                    dates.append(date)
                }
            }
        }

        return dates
    }

    // Checks if two dates are the same
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

// Placeholder ConfirmTimePage
struct ConfirmTimePage: View {
    var selectedDate: Date
    
    var body: some View {
        Text("Selected Date: \(selectedDate, formatter: dateFormatter)")
            .font(.title)
            .padding()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

// Preview
struct SelectDayPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectDayPage()
        }
    }
}
