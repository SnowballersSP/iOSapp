import SwiftUI

struct SelectDayPage: View {
    @State private var selectedDate = Date()
    @State private var selectedHour = 12
    @State private var selectedMinute = 0
    @State private var selectedPeriod = "AM"

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

            // Calendar Grid (Fixing the missing scope issue)
            CalendarView(selectedDate: $selectedDate)

            // Time Picker Section
            VStack {
                Text("Select Time")
                    .font(.headline)
                    .padding(.top, 10)

                HStack {
                    // Hour Picker
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(1...12, id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)

                    Text(":")

                    // Minute Picker
                    Picker("Minute", selection: $selectedMinute) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)

                    // AM/PM Picker
                    Picker("AM/PM", selection: $selectedPeriod) {
                        Text("AM").tag("AM")
                        Text("PM").tag("PM")
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)
                }
                .frame(height: 100) // Set height to ensure visibility
            }

            Spacer()

            // Confirm Selection Button
            NavigationLink(destination: ConfirmTimePage(
                selectedDate: selectedDate,
                selectedHour: selectedHour,
                selectedMinute: selectedMinute,
                selectedPeriod: selectedPeriod
            )) {
                Text("Confirm Date & Time")
                    .frame(width: 250, height: 50)
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

// ✅ Adding CalendarView here to ensure it is in scope
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

    private func generateCalendarDays() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: selectedDate)
        let currentYear = calendar.component(.year, from: selectedDate)

        if let dayRange = calendar.range(of: .day, in: .month, for: selectedDate) {
            for day in dayRange {
                if let date = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: day)) {
                    dates.append(date)
                }
            }
        }
        return dates
    }

    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

// ✅ Ensure ConfirmTimePage exists and has the correct parameters
struct ConfirmTimePage: View {
    var selectedDate: Date
    var selectedHour: Int
    var selectedMinute: Int
    var selectedPeriod: String

    var body: some View {
        VStack {
            Text("Confirmation")
                .font(.title)
                .padding()

            Text("Selected Date:")
                .font(.headline)
            Text("\(formattedDate)")
                .font(.title2)
                .padding(.bottom)

            Text("Selected Time:")
                .font(.headline)
            Text("\(selectedHour):\(String(format: "%02d", selectedMinute)) \(selectedPeriod)")
                .font(.title2)

            Spacer()
        }
        .padding()
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
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
