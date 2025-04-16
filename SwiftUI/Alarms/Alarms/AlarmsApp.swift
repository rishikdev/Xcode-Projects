//
//  AlarmsApp.swift
//  Alarms
//
//  Created by Rishik Dev on 01/08/23.
//

import SwiftUI
import UserNotifications

@main
struct AlarmsApp: App {
    @AppStorage("isFirstLaunch") var isFirstlaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
                    if(isFirstlaunch) {
                        isFirstlaunch = false
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isSuccess, error in
                            if let error = error {
                                print(error)
                            }
                        }
                    }
                }
        }
    }
}
