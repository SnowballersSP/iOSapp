import SwiftUI

struct SavedSchedulePage: View {
    @State private var scheduledCleanings: [String] = []
    @State private var selectedEditingIndex: Int? = nil // Track selected index for navigation

    var body: some View {
        NavigationStack {
            VStack {
                Text("Saved Schedulings")
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
            }
            .onAppear(perform: loadScheduledCleanings)
            .padding()
        }
    }

    // Load saved schedules from UserDefaults
    private func loadScheduledCleanings() {
        scheduledCleanings = UserDefaults.standard.array(forKey: "ScheduledCleanings") as? [String] ?? []
    }

    // Delete a schedule from the list
    private func deleteSchedule(at index: Int) {
        scheduledCleanings.remove(at: index)
        UserDefaults.standard.set(scheduledCleanings, forKey: "ScheduledCleanings")
    }

    // Edit a schedule
    private func editSchedule(at index: Int) {
        selectedEditingIndex = index // Triggers navigation
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
