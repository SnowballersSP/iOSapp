import SwiftUI

struct TimerPage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Timer Page")
                    .font(.largeTitle)
                    .padding()

                // Navigation Button to TimerArea
                NavigationLink(destination: TimerArea()) {
                    Text("Go to Timer Area")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
}

// Preview
struct TimerPage_Previews: PreviewProvider {
    static var previews: some View {
        TimerPage()
    }
}
