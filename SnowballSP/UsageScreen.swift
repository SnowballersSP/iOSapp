import SwiftUI

struct UsageScreen: View {
    let months = ["This Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    var body: some View {
        VStack {
            Text("View Usage")
                .font(.title)
                .padding()

            List(months, id: \.self) { month in
                NavigationLink(destination: month == "This Month" ? AnyView(MonthScreen()) : AnyView(EmptyView())) {
                    Text(month)
                        .padding()
                }
            }
        }
    }
}

struct UsageScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsageScreen()
        }
    }
}
