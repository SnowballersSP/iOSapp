//
//  SnowballSPApp.swift
//  SnowballSP
//
//  Created by Brianna John on 2/4/25.
//

import SwiftUI
import UserNotifications

@main
struct SnowballSPApp: App {
    init() {
            requestNotificationPermission()
        }
    var body: some Scene {
        WindowGroup {
            LoginSignupPage()
        }
    }
    func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("✅ Notification permission granted!")
                } else if let error = error {
                    print("❌ Notification permission denied: \(error.localizedDescription)")
                }
            }
        }
}

// Handle notification tap behavior
class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationHandler()

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("🔔 User tapped notification!")
        completionHandler()
    }
}
