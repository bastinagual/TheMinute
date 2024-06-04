//
//  TheMinuteApp.swift
//  TheMinute
//
//  Created by Sébastien Roger on 01.06.24.
//

import SwiftUI

@main
struct TheMinuteApp: App {
    let notificationService = NotificationService()
    let timerViewModel: TimerViewModel
    init() {
        timerViewModel = TimerViewModel(notificationService: notificationService)
        notificationService.requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            TimerView(timerViewModel: timerViewModel)
        }
    }
}
