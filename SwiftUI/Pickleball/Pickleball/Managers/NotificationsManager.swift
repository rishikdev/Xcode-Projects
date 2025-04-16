//
//  NotificationsManager.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import Foundation
import UserNotifications

actor NotificationsManager {
    private init() { }
    
    static let shared = NotificationsManager()
    
    func requestNotificationsAuthorisation() async throws -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            throw error
        }
    }
    
    func getNotificationsAuthorisationStatus() async -> UNAuthorizationStatus {
        return await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
}
