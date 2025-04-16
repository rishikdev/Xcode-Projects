//
//  SettingsViewModel.swift
//  Pickleball
//
//  Created by Rishik Dev on 04/12/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

enum OperationStatus {
    case reset
    case initiated
    case success
    case failure
}

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var operationStatus: OperationStatus = .reset
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    let firebaseUserAuthentication: FirebaseUserAuthenticationManager
    
    init(firebaseUserAuthentication: FirebaseUserAuthenticationManager) {
        self.firebaseUserAuthentication = firebaseUserAuthentication
    }
    
    func logout() {
        do {
            self.operationStatus = .initiated
            try firebaseUserAuthentication.signOut()
            self.onOperationSuccess(operation: .success)
        } catch {
            self.onOperationFailure(alertMessage: error.localizedDescription, operation: .failure)
        }
    }
    
    func deleteAccount(of user: User) {
        Task {
            do {
                self.operationStatus = .initiated
                try await firebaseUserAuthentication.deleteAccount(user: user)
                self.onOperationSuccess(operation: .success)
            } catch {
                self.onOperationFailure(alertMessage: error.localizedDescription, operation: .failure)
            }
        }
    }
    
    private func onOperationSuccess(operation: OperationStatus) {
        self.operationStatus = .success
    }
    
    private func onOperationFailure(alertMessage: String, operation: OperationStatus) {
        self.operationStatus = .failure
        self.alertTitle = Constants.Alert.Title.signOutFailed.rawValue.key
        self.alertMessage = alertMessage
    }
}
