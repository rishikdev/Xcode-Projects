//
//  NotificationsViewModel.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import Foundation

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var hasAuthorisation: Bool = false
    @Published var presentAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    let notificationsManager: NotificationsManager
    
    init(notificationsManager: NotificationsManager) {
        self.notificationsManager = notificationsManager
        self.getNotificationsAuthorisationStatus()
    }
    
    func requestNotificationsAuthorisation() {
        Task {
            do {
                self.hasAuthorisation = try await notificationsManager.requestNotificationsAuthorisation()
            } catch {
                self.presentAlert = true
                self.alertTitle = Constants.Alert.Title.error.rawValue.key
                self.alertMessage = error.localizedDescription
            }
        }
    }
    
    func getNotificationsAuthorisationStatus() {
        Task {
            let status = await notificationsManager.getNotificationsAuthorisationStatus()
            
            switch status {
            case .authorized, .provisional, .ephemeral:
                self.hasAuthorisation = true
                
                default :
                self.hasAuthorisation = false
            }
        }
    }
}
