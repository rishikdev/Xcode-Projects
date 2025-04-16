//
//  AuthenticationViewModel.swift
//  Pickleball
//
//  Created by Rishik Dev on 05/12/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

enum UserAuthenticationStatus {
    case reset
    case unauthenticated
    case authenticated
    case unknown
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var userAuthenticationStatus: UserAuthenticationStatus = .reset
    @Published var user: User?
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.userAuthenticationStatus = .reset
        self.registerAuthStateHandler()
    }
    
    private func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.user?.displayName = user?.email ?? "Unknown"
                
                withAnimation {
                    self.userAuthenticationStatus = user == nil ? .unauthenticated : .authenticated
                }
            }
        }
    }
}
