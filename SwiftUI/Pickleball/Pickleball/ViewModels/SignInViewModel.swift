//
//  SignInViewModel.swift
//  Pickleball
//
//  Created by Rishik Dev on 19/11/24.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import CryptoKit

enum AuthenticationFlowStatus {
    case reset
    case initiated
    case successful
    case unsuccessful
}

@MainActor
class SignInViewModel: ObservableObject {
    @Published var emailFormatSatisfied: Bool = false
    @Published var passwordRequirementSatisfied: Bool = false
    @Published var authenticationFlowStatus: AuthenticationFlowStatus = .reset
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private var currentNonce: String?
    
    let firebaseUserAuthentication: FirebaseUserAuthenticationManager
    
    init(firebaseUserAuthentication: FirebaseUserAuthenticationManager) {
        self.firebaseUserAuthentication = firebaseUserAuthentication
    }
    
    func signInWithAppleHandleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        self.authenticationFlowStatus = .initiated
        
        let nonce = Encryption.randomNonceString()
        currentNonce = nonce
        request.nonce = Encryption.sha256(nonce)
    }
    
    /// Referred the following video - https://www.youtube.com/watch?v=HyiNbqLOCQ8
    func signInWithAppleHandleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let success):
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Failed to get identity token")
                    self.onLoginFailure(alertMessage: Constants.Alert.Message.unknownError.rawValue.key)
                    return
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    self.onLoginFailure(alertMessage: Constants.Alert.Message.unknownError.rawValue.key)
                    return
                }
                
                let credential = OAuthProvider.credential(providerID: .apple,
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                Task {
                    do {
                        let _ = try await firebaseUserAuthentication.signInWithApple(credential: credential) // The return value can be used to get user information such as name, email, etc.
                        self.onLoginSuccess()
                    } catch let error as FirebaseAuthError {
                        self.onLoginFailure(alertMessage: error.localisedDescription)
                    } catch {
                        self.onLoginFailure(alertMessage: error.localizedDescription)
                    }
                }
            }
        case .failure(let error):
            if error is ASAuthorizationError {
                self.onLoginFailure(authenticationFlowStatus: .reset, alertMessage: error.localizedDescription)
            } else {
                self.onLoginFailure(alertMessage: error.localizedDescription)
            }
        }
    }
    
    func signInWithGoogle() async {
        self.authenticationFlowStatus = .initiated
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            self.onLoginFailure(alertMessage: Constants.Alert.Message.signInWithGoogleCouldNotBePresented.rawValue.key)
            return
        }
        
        Task {
            do {
                let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = userAuthentication.user
                
                try await firebaseUserAuthentication.signInWithGoogle(user: user)
                self.onLoginSuccess()
                
            } catch let error as GIDSignInError {
                if (error.code == .canceled || error.code.rawValue == -1) {
                    // error.code.rawValue = -1 signifies that the user declined to connect their Google account with OPR
                    self.onLoginFailure(authenticationFlowStatus: .reset, alertMessage: error.localizedDescription)
                } else {
                    self.onLoginFailure(alertMessage: error.localizedDescription)
                }
            } catch {
                self.onLoginFailure(alertMessage: error.localizedDescription)
            }
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        Task {
            do {
                self.authenticationFlowStatus = .initiated
                try await firebaseUserAuthentication.signInWithEmailPassword(email: email, password: password)
                self.onLoginSuccess()
            } catch let error as FirebaseAuthError {
                self.onLoginFailure(alertMessage: error.localisedDescription)
            } catch {
                self.onLoginFailure(alertMessage: error.localizedDescription)
            }
        }
    }
    
    func validateEmailFormat(email: String) {
        self.emailFormatSatisfied = InputValidation.isValidEmailFormat(email: email)
    }
    
    func validatePassword(password: String) {
        self.passwordRequirementSatisfied = !password.isEmpty
    }
    
    func shouldEnableSubmit() -> Bool {
        emailFormatSatisfied
        && passwordRequirementSatisfied
        && (authenticationFlowStatus == .reset || authenticationFlowStatus == .unsuccessful)
    }
    
    func resetViewModel() {
        emailFormatSatisfied = false
        passwordRequirementSatisfied = false
        authenticationFlowStatus = .reset
        alertTitle = ""
        alertMessage = ""
    }
    
    private func onLoginSuccess(authenticationFlowStatus: AuthenticationFlowStatus = .successful) {
        self.authenticationFlowStatus = .successful
    }
    
    private func onLoginFailure(authenticationFlowStatus: AuthenticationFlowStatus = .unsuccessful, alertMessage: String) {
        self.authenticationFlowStatus = authenticationFlowStatus
        self.alertTitle = Constants.Alert.Title.signInFailed.rawValue.key
        self.alertMessage = alertMessage
    }
}
