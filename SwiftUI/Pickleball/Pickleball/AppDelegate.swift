//
//  AppDelegate.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        // Comment or remove the below Auth.auth() line to start using remote Firebase console.
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .sound, .list]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        
    }
    
    @MainActor
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        
        return UIBackgroundFetchResult.newData
    }
}

extension AppDelegate: MessagingDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String?) {
#if DEBUG
        print("FCMToken: \(fcmToken ?? "NONE")")
#endif
    }
}
