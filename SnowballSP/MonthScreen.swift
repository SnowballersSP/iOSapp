import SwiftUI

struct MonthScreen: View {
    @State private var selectedDate: Date = Date() // Store selected date

    var body: some View {
        VStack {
            Text("Usage this month")
                .font(.title)
                .padding()

            // Pass selectedDate as a Binding
            CalendarView(selectedDate: $selectedDate)
                .padding()

            Spacer()
        }
    }
}

struct MonthScreen_Previews: PreviewProvider {
    static var previews: some View {
        MonthScreen()
    }
}
