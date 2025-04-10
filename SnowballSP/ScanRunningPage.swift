import SwiftUI
import UserNotifications

struct ScanRunningPage: View {
    @State private var timeRemaining: Int = 120 // 2 minutes
    @State private var timerRunning = true
    @State private var timer: Timer? = nil
    @State private var navigateToTimerArea = false
    @State private var navigateToCongratsScreen = false


    var body: some View {
        VStack {
            Text("SnowBall Running...")
                .font(.largeTitle)
                .padding()

            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Circle()
                    .trim(from: 0.0, to: CGFloat(timeRemaining) / 120.0)
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: timeRemaining)

                Text(timeString(time: timeRemaining))
                    .font(.largeTitle)
                    .monospaced()
            }
            .frame(width: 200, height: 200)
            .padding()

            Button(action: cancelTimer) {
                Text("Cancel")
                    .frame(width: 150, height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()
        }
        .onAppear {
            startTimer()
            //requestNotificationPermission()
        }
        .navigationDestination(isPresented: $navigateToTimerArea) {
            HomePage()
        }
        .navigationDestination(isPresented: $navigateToCongratsScreen) {
            CongratsScreen()
        }

    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 60 {
                    sendNotification(title: "1 Minute Left", body: "Your cleaning cycle has 1 minute remaining.")
                }
            } else {
                timer?.invalidate()
                sendNotification(title: "Cleaning Complete", body: "Your cleaning cycle has finished.")
                // Navigate to CongratsScreen
                navigateToCongratsScreen = true
            }
        }
    }

    private func cancelTimer() {
        timer?.invalidate()
        sendNotification(title: "Cleaning Canceled", body: "The cleaning cycle has been stopped.")
        //return home
        navigateToTimerArea = true
    }

    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // Add a small delay to ensure notifications are shown
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        DispatchQueue.main.async {
            UNUserNotificationCenter.current().add(request)
        }
    }


//    private func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
//    }
    
}

// Preview
struct ScanRunningPage_Previews: PreviewProvider {
    static var previews: some View {
        ScanRunningPage()
    }
}
