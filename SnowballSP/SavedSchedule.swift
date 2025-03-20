import SwiftUI

struct SavedSchedulePage: View {
    @State private var schedules: [String] = []
    private let loggedInUser = UserDefaults.standard.string(forKey: "loggedInUser") ?? ""

    var body: some View {
        VStack {
            Text("Your Saved Schedules")
                .font(.title)
                .padding()

            if schedules.isEmpty {
                Text("No saved schedules yet!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(schedules.indices, id: \.self) { index in
                        Text(schedules[index])
                            .swipeActions {
                                Button("Delete", role: .destructive) {
                                    deleteSchedule(at: index)
                                }
                                Button("Edit") {
                                    editSchedule(at: index)
                                }
                            }
                    }
                }
            }

            Spacer()

            // Return to home button
            NavigationLink(destination: HomePage()) {
                Text("Return Home")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20) // Add some padding to ensure button is not too close to the bottom
        }
        .onAppear {
            loadUserSchedules()
        }
    }

    // Load the logged-in user's saved schedules
    private func loadUserSchedules() {
        if let allSchedules = UserDefaults.standard.dictionary(forKey: "ScheduledCleanings") as? [String: [String]] {
            schedules = allSchedules[loggedInUser] ?? []
        }
    }

    // Delete a schedule from the user’s data
    private func deleteSchedule(at index: Int) {
        schedules.remove(at: index)
        saveUserSchedules()
    }

    // Edit functionality — navigates back to ConfirmTimePage with prefilled data
    private func editSchedule(at index: Int) {
        let scheduleParts = schedules[index].components(separatedBy: ": ")
        let area = scheduleParts[0]
        let dateTime = scheduleParts[1].components(separatedBy: " @ ")
        let date = dateTime[0]
        let timeParts = dateTime[1].components(separatedBy: " ")

        // Extracting time details
        let time = timeParts[0].components(separatedBy: ":")
        let hour = Int(time[0]) ?? 0
        let minute = Int(time[1]) ?? 0
        let period = timeParts[1]

        // Navigate to ConfirmTimePage with editingIndex set
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: ConfirmTimePage(
                selectedArea: area,
                selectedDate: parseDate(from: date),
                selectedHour: hour,
                selectedMinute: minute,
                selectedPeriod: period,
                editingIndex: index
            ))
            window.makeKeyAndVisible()
        }
    }

    // Save schedules specifically for the logged-in user
    private func saveUserSchedules() {
        var allSchedules = UserDefaults.standard.dictionary(forKey: "ScheduledCleanings") as? [String: [String]] ?? [:]
        allSchedules[loggedInUser] = schedules
        UserDefaults.standard.set(allSchedules, forKey: "ScheduledCleanings")
    }

    // Parse date string (e.g., "March 12, 2025") back into Date
    private func parseDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.date(from: dateString) ?? Date()
    }
}

// Preview
struct SavedSchedulePage_Previews: PreviewProvider {
    static var previews: some View {
        SavedSchedulePage()
    }
}
