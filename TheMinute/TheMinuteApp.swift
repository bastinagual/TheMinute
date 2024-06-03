//
//  TheMinuteApp.swift
//  TheMinute
//
//  Created by Sébastien Roger on 01.06.24.
//

import SwiftUI

@main
struct TheMinuteApp: App {
    var timerViewModel = TimerViewModel()
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(timerViewModel: timerViewModel)
        }
    }
}
