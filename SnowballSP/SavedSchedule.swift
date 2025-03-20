import SwiftUI

struct SavedSchedulePage: View {
    @State private var scheduledCleanings: [String] = []
    @State private var selectedEditingIndex: Int? = nil
    @State private var showReturnHomeButton: Bool = true
    
    //  Track the current logged-in user
    @State private var currentUser: String = UserDefaults.standard.string(forKey: "loggedInUser") ?? "Guest"
    
    var body: some View {
        NavigationStack {
            VStack {
                // Show the current user's saved schedules
                Text("\(currentUser)'s Saved Schedules")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if scheduledCleanings.isEmpty {
                    Text("No scheduled cleanings yet.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(scheduledCleanings.indices, id: \.self) { index in
                            HStack {
                                Text(scheduledCleanings[index])

                                Spacer()

                                // Edit Button
                                Button(action: {
                                    editSchedule(at: index)
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())

                                // Delete Button
                                Button(action: {
                                    deleteSchedule(at: index)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .background(
                                NavigationLink(
                                    destination: SelectDayPage(
                                        selectedArea: extractArea(from: scheduledCleanings[index]),
                                        existingDateAndTime: extractDateAndTime(from: scheduledCleanings[index]),
                                        editingIndex: index
                                    ),
                                    tag: index,
                                    selection: $selectedEditingIndex
                                ) { EmptyView() }
                                .opacity(0) // Invisible NavigationLink
                            )
                        }
                    }
                }

                Spacer()

                if showReturnHomeButton {
                    NavigationLink(destination: HomePage()) {
                        Text("Return Home")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                }
            }
            .onAppear(perform: loadScheduledCleanings)
            .padding()
        }
    }

    // Load saved schedules specific to the current user
    private func loadScheduledCleanings() {
        let key = "ScheduledCleanings_\(currentUser)"
        scheduledCleanings = UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }

    //  Save schedule changes specific to the current user
    private func saveScheduledCleanings() {
        let key = "ScheduledCleanings_\(currentUser)"
        UserDefaults.standard.set(scheduledCleanings, forKey: key)
    }

    // Delete a schedule from the list
    private func deleteSchedule(at index: Int) {
        scheduledCleanings.remove(at: index)
        saveScheduledCleanings()
        showReturnHomeButton = true
    }

    // Edit a schedule
    private func editSchedule(at index: Int) {
        selectedEditingIndex = index // Triggers navigation
        showReturnHomeButton = true
    }

    // Extract area from saved string format
    private func extractArea(from schedule: String) -> String {
        let components = schedule.components(separatedBy: ": ")
        return components.first ?? ""
    }

    // Extract date and time from saved string format
    private func extractDateAndTime(from schedule: String) -> String {
        let components = schedule.components(separatedBy: ": ")
        return components.count > 1 ? components[1] : ""
    }
}
