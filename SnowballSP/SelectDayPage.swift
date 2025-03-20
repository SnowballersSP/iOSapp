import SwiftUI

struct SelectDayPage: View {
    var selectedArea: String
    var existingDateAndTime: String? = nil // Added optional parameter for editing mode
    var editingIndex: Int? = nil           // Added optional parameter for tracking the editing index
    
    @State private var selectedDate = Date()
    @State private var selectedHour = 12
    @State private var selectedMinute = 0
    @State private var selectedPeriod = "AM"

    init(selectedArea: String, existingDateAndTime: String? = nil, editingIndex: Int? = nil) { // Updated initializer
        self.selectedArea = selectedArea
        self.existingDateAndTime = existingDateAndTime
        self.editingIndex = editingIndex

        if let dateAndTime = existingDateAndTime {
            self._selectedDate = State(initialValue: parseDate(from: dateAndTime)) // Pre-fill date
            let parsedTime = parseTime(from: dateAndTime)
            self._selectedHour = State(initialValue: parsedTime.hour) // Pre-fill hour
            self._selectedMinute = State(initialValue: parsedTime.minute) // Pre-fill minute
            self._selectedPeriod = State(initialValue: parsedTime.period) // Pre-fill AM/PM
        }
    }

    var body: some View {
        VStack {
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

            CalendarView(selectedDate: $selectedDate)

            // Time Picker Section
            VStack {
                Text("Select Time")
                    .font(.headline)
                    .padding(.top, 10)

                HStack {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(1...12, id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)

                    Text(":")

                    Picker("Minute", selection: $selectedMinute) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)

                    Picker("AM/PM", selection: $selectedPeriod) {
                        Text("AM").tag("AM")
                        Text("PM").tag("PM")
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 80)
                }
                .frame(height: 100)
            }

            Spacer()

            NavigationLink(destination: ConfirmTimePage(
                selectedArea: selectedArea,
                selectedDate: selectedDate,
                selectedHour: selectedHour,
                selectedMinute: selectedMinute,
                selectedPeriod: selectedPeriod,
                editingIndex: editingIndex // Pass editing index
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

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    // Function to parse a date from an existing schedule string
    private func parseDate(from dateTimeString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy @ h:mm a"
        return formatter.date(from: dateTimeString) ?? Date() // Default to current date if parsing fails
    }

    // Function to parse time components from an existing schedule string
    private func parseTime(from dateTimeString: String) -> (hour: Int, minute: Int, period: String) {
        let components = dateTimeString.components(separatedBy: ["@", ":", " "]).map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count >= 4, let hour = Int(components[1]), let minute = Int(components[2]) else {
            return (12, 0, "AM") // Default to 12:00 AM if parsing fails
        }
        return (hour, minute, components[3])
    }
}

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

struct ConfirmTimePage: View {
    var selectedArea: String
    var selectedDate: Date
    var selectedHour: Int
    var selectedMinute: Int
    var selectedPeriod: String
    var editingIndex: Int? // for edit index

    @State private var navigateToSavedSchedule = false

    var body: some View {
        VStack {
            Text("Confirmation")
                .font(.title)
                .padding()

            Text("Selected Area:")
                .font(.headline)
            Text(selectedArea)
                .font(.title2)
                .padding(.bottom)

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

            Button(action: saveScheduledCleaning) {
                Text("Confirm & Save")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            // Navigation trigger
            NavigationLink(
                destination: SavedSchedulePage(),
                isActive: $navigateToSavedSchedule
            ) { EmptyView() }

        }
        .padding()
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }

    private func saveScheduledCleaning() {
        let defaults = UserDefaults.standard
        let currentUser = defaults.string(forKey: "loggedInUser") ?? "Guest"
        let userKey = "ScheduledCleanings_\(currentUser)"
        
        let newSchedule = "\(selectedArea): \(formattedDate) @ \(selectedHour):\(String(format: "%02d", selectedMinute)) \(selectedPeriod)"
        
        var savedSchedules = defaults.array(forKey: userKey) as? [String] ?? []

        if let index = editingIndex {
            // Editing existing schedule
            savedSchedules[index] = newSchedule
        } else {
            // Adding new schedule
            savedSchedules.append(newSchedule)
        }
        
        defaults.set(savedSchedules, forKey: userKey)
        
        // Navigate after saving
        navigateToSavedSchedule = true
    }

}


struct SelectDayPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectDayPage(selectedArea: "Front Garage", existingDateAndTime: "March 5, 2025 @ 10:30 AM", editingIndex: 0) // Example preview for editing
        }
    }
}
