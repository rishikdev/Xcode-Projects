//
//  SettingsView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI
import FirebaseMessaging

struct SettingsView: View {
    @Environment(\.colorScheme) private var colourScheme
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject private var settingsViewModel: SettingsViewModel = .init(firebaseUserAuthentication: FirebaseUserAuthenticationManager.shared)
    
    @State private var presentAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome \(authenticationViewModel.user?.displayName ?? "Unknown User")")
                
                AuthenticationButtonView(text: Constants.ButtonText.signOut.rawValue,
                                         textColour: colourScheme == .light ? .white : .black,
                                         tint: colourScheme == .light ? .black : .white) {
                    logout()
                }
                
                AuthenticationButtonView(text: Constants.ButtonText.deleteAccount.rawValue,
                                         tint: .red) {
                    deleteAccount()
                }
                                         .disabled(authenticationViewModel.user == nil)
                
                                         .onChange(of: settingsViewModel.operationStatus) { operationStatus in
                                             if (operationStatus == .failure) {
                                                 presentAlert = true
                                             }
                                         }
                
                TintedButtonView(text: "Subscribe to Club 1") {
                    Messaging.messaging().subscribe(toTopic: "1")
                }
                
                TintedButtonView(text: "Subscribe to Club 2") {
                    Messaging.messaging().subscribe(toTopic: "2")
                }
                
                TintedButtonView(text: "Unsubscribe from Club 1", tint: .red) {
                    Messaging.messaging().unsubscribe(fromTopic: "1")
                }
                
                TintedButtonView(text: "Unsubscribe from Club 2", tint: .red) {
                    Messaging.messaging().unsubscribe(fromTopic: "2")
                }
            }
            .alert(settingsViewModel.alertTitle, isPresented: $presentAlert, actions: {
                Button("Dismiss", role: .cancel) { }
            }, message: {
                Text(settingsViewModel.alertMessage)
            })
            .padding()
            .navigationTitle(Constants.ViewTitle.settings.rawValue.key)
        }
    }
    
    func logout() {
        settingsViewModel.logout()
    }
    
    func deleteAccount() {
        settingsViewModel.deleteAccount(of: authenticationViewModel.user!)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AuthenticationViewModel())
    }
}
