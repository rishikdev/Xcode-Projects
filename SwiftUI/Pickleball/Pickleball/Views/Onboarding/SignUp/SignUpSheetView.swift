//
//  SignUpSheetView.swift
//  Pickleball
//
//  Created by Rishik Dev on 06/11/24.
//

import SwiftUI

struct SignUpSheetView: View {
    @Binding var isPresented: Bool
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject private var signUpViewModel: SignUpViewModel = .init(firebaseUserAuthentication: FirebaseUserAuthenticationManager.shared)
    
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var dateOfBirth: Date = .now
    @State private var email: String = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var presentAlert: Bool = false
    
    var body: some View {
        ZStack {
            if(signUpViewModel.signUpStatus == .initiated) {
                ProgressView(Constants.ProgressViewText.signingUp.rawValue.key)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: Constants.Spacing.small.rawValue))
            } else {
                ScrollView {
                    VStack(alignment: .center, spacing: Constants.Spacing.large.rawValue) {
                        
                        // MARK: - Profile Photo Selection
                        ProfilePhotoSelectionView()
                        
                        // MARK: - Basic Details
                        BasicDetailsInputView(firstName: $firstName,
                                              middleName: $middleName,
                                              lastName: $lastName,
                                              dateOfBirth: $dateOfBirth,
                                              firstNameSatisfied: signUpViewModel.firstNameSatisfied,
                                              lastNameSatisfied: signUpViewModel.lastNameSatisfied,
                                              onFirstNameChange: { firstName in
                            signUpViewModel.validateFirstName(firstName: firstName)
                        },
                                              onLastNameChange: { lastName in
                            signUpViewModel.validateLastName(lastName: lastName)
                        })
                        .roundGrayBackground()
                        
                        // MARK: - Email
                        EmailInputView(email: $email,
                                       emailFormatSatisfied: signUpViewModel.emailFormatSatisfied,
                                       onEmailChange: { email in
                            signUpViewModel.validateEmailFormat(email: email)
                        })
                        .roundGrayBackground()
                        
                        // MARK: - Password
                        PasswordInputView(password: $password,
                                          passwordRequirementCharacterCountSatisfied: signUpViewModel.passwordRequirementCharacterCountSatisfied,
                                          passwordRequirementUppercaseCharacterSatisfied: signUpViewModel.passwordRequirementUppercaseCharacterSatisfied,
                                          passwordRequirementLowercaseCharacterSatisfied: signUpViewModel.passwordRequirementLowercaseCharacterSatisfied,
                                          passwordRequirementNumberSatisfied: signUpViewModel.passwordRequirementNumberSatisfied,
                                          passwordRequirementSpecialCharacterSatisfied: signUpViewModel.passwordRequirementSpecialCharacterSatisfied,
                                          passwordsMatch: signUpViewModel.passwordsMatch,
                                          onPasswordChange: { password in
                            withAnimation {
                                signUpViewModel.validatePassword(password: password)
                                
                                if(confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).count > 0) {
                                    signUpViewModel.validateConfirmPasswords(password: password,
                                                                             confirmPassword: confirmPassword)
                                }
                            }
                        })
                        .roundGrayBackground()
                        
                        // MARK: - Confirm Password
                        ConfirmPasswordInputView(confirmPassword: $confirmPassword,
                                                 passwordsMatch: signUpViewModel.passwordsMatch,
                                                 onConfirmPasswordChange: { confirmPassword in
                            withAnimation {
                                signUpViewModel.validateConfirmPasswords(password: password,
                                                                         confirmPassword: confirmPassword)
                            }
                        })
                        .roundGrayBackground()
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                }
            }
        }
        .toolbar {
            // MARK: - Cancel Button
            ToolbarItem(placement: .cancellationAction) {
                TintedButtonView(text: Constants.ButtonText.cancel.rawValue,
                                 tint: .red) { isPresented = false }
            }
            
            // MARK: - Submit Button
            ToolbarItem(placement: .confirmationAction) {
                TintedButtonView(text: Constants.ButtonText.submit.rawValue,
                                 tint: .blue) {
                    onSignUpSubmit()
                }
                .disabled(!signUpViewModel.shouldEnableSubmit())
            }
        }
        .alert(signUpViewModel.alertTitle,
               isPresented: $presentAlert,
               actions: {
            Button(Constants.ButtonText.dismiss.rawValue.key, role: .cancel) {
                
                if (signUpViewModel.signUpStatus == .success) {
                    isPresented = false
                    authenticationViewModel.userAuthenticationStatus = .authenticated
                }
            }
        },
               message: {
            Text(signUpViewModel.alertMessage)
        })
        .onChange(of: signUpViewModel.signUpStatus) { signUpStatus in
            presentAlert = signUpStatus == .success || signUpStatus == .failure
        }
        .interactiveDismissDisabled()
        .navigationTitle(Constants.ViewTitle.signUp.rawValue.key)
    }
    
    // MARK: - onSubmit()
    func onSignUpSubmit() {
        signUpViewModel.signUpWithEmail(email: email, password: password)
    }
}

#Preview {
    NavigationStack {
        SignUpSheetView(isPresented: .constant(true))
            .environmentObject(AuthenticationViewModel())
    }
}
