//
//  NotificationService.swift
//  TheMinute
//
//  Created by Sébastien Roger on 03.06.24.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestNotificationPermissions()
    func scheduleNotification (timeInterval: TimeInterval)
    func cancelScheduledNotification()
}

public class NotificationService: NotificationServiceProtocol {
    private var currentNotificationRequest: UNNotificationRequest?
    
    public func requestNotificationPermissions () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }

    public func scheduleNotification(timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "The minute is over!"
        content.subtitle = "The timer is done"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let newRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(newRequest)
        currentNotificationRequest = newRequest
    }
    
    public func cancelScheduledNotification() {
        if let identifier = currentNotificationRequest?.identifier {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
}


public class NotificationServiceMock : NotificationServiceProtocol {
    func requestNotificationPermissions() {
        print("permissions requested")
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        print("notification scheduled")
    }
    
    func cancelScheduledNotification() {
        print("notification cancelled")
    }
}
