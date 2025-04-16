//
//  ControllerView.swift
//  Pickleball
//
//  Created by Rishik Dev on 04/12/2024.
//

import SwiftUI

struct ControllerView: View {
    @StateObject private var authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel()
    @StateObject private var notificationsViewModel: NotificationsViewModel = .init(notificationsManager: NotificationsManager.shared)
    
    var body: some View {
        VStack {
            switch authenticationViewModel.userAuthenticationStatus {
            case .unauthenticated, .unknown:
                OnboardingView()
            case .authenticated:
                HomeView()
            case .reset:
                ProgressView(Constants.Text.loading.rawValue.key)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: Constants.Spacing.small.rawValue))
            }
        }
        .onAppear {
            if (!notificationsViewModel.hasAuthorisation) {
                self.notificationsViewModel.requestNotificationsAuthorisation()
            }
        }
        .environmentObject(authenticationViewModel)
    }
}

#Preview {
    ControllerView()

}
