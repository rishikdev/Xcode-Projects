//
//  OnboardingView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @Environment(\.colorScheme) private var colourScheme
    @EnvironmentObject private var authenticationViewModel: AuthenticationViewModel
    @StateObject private var signInViewModel: SignInViewModel = .init(firebaseUserAuthentication: FirebaseUserAuthenticationManager.shared)
    
    @State private var presentAlert: Bool = false
    @State private var showSignUpSheet: Bool = false
    @State private var disableInteraction: Bool = false
    
    var body: some View {
        ZStack() {
            VStack {
                BrandImageView()
                loginOptions
            }
            .disabled(disableInteraction)
            
            if(disableInteraction) {
                ProgressView(Constants.Text.loading.rawValue.key)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: Constants.Spacing.small.rawValue))
            }
        }
        .animation(.smooth, value: signInViewModel.authenticationFlowStatus)
        .alert(signInViewModel.alertTitle,
               isPresented: $presentAlert,
               actions: {
            Button(Constants.ButtonText.dismiss.rawValue.key, role: .cancel) {
                signInViewModel.authenticationFlowStatus = .reset
            }
        },
               message: {
            Text(signInViewModel.alertMessage)
        })
        .sheet(isPresented: $showSignUpSheet) {
            NavigationStack {
                SignUpSheetView(isPresented: $showSignUpSheet)
            }
        }
        .onChange(of: signInViewModel.authenticationFlowStatus) { authFlowStatus in
            withAnimation {
                switch authFlowStatus {
                case .reset:
                    self.disableInteraction = false
                case .initiated:
                    self.disableInteraction = true
                case .successful:
                    self.disableInteraction = true
                    withAnimation {
                        authenticationViewModel.userAuthenticationStatus = .authenticated
                    }
                case .unsuccessful:
                    self.disableInteraction = false
                    self.presentAlert = true
                }
            }
        }
    }
    
    var loginOptions: some View {
        ScrollView {
            VStack(spacing: Constants.Spacing.medium.rawValue) {
                SignInWithEmailPasswordView(signInViewModel: signInViewModel)
                
                ZStack {
                    Divider()
                    Text(Constants.Text.or.rawValue.key)
                        .padding(.horizontal)
                        .background()
                        .foregroundStyle(.gray)
                }
                
                SignInWithAppleView(signInViewModel: signInViewModel,
                                    disableInteraction: $disableInteraction)
                SignInWithGoogleView(signInViewModel: signInViewModel)
                
                AuthenticationButtonView(text: Constants.ButtonText.signUp.rawValue,
                                         textColour: colourScheme == .light ? .white : .black,
                                         tint: colourScheme == .light ? .black : .white) {
                    showSignUpSheet.toggle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthenticationViewModel())
}
