//
//  SignUpViewModel.swift
//  Pickleball
//
//  Created by Rishik Dev on 06/11/24.
//

import Foundation

enum SignUpStatus {
    case reset
    case initiated
    case success
    case failure
}

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var firstNameSatisfied: Bool = false
    @Published var lastNameSatisfied: Bool = false
    @Published var emailFormatSatisfied: Bool = false
    @Published var passwordRequirementCharacterCountSatisfied: Bool = false
    @Published var passwordRequirementUppercaseCharacterSatisfied: Bool = false
    @Published var passwordRequirementLowercaseCharacterSatisfied: Bool = false
    @Published var passwordRequirementNumberSatisfied: Bool = false
    @Published var passwordRequirementSpecialCharacterSatisfied: Bool = false
    @Published var passwordsMatch: Bool = false
    
    @Published var signUpStatus: SignUpStatus = .reset
    
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    let firebaseUserAuthentication: FirebaseUserAuthenticationManager
    
    init(firebaseUserAuthentication: FirebaseUserAuthenticationManager) {
        self.firebaseUserAuthentication = firebaseUserAuthentication
    }
    
    func signUpWithEmail(email: String, password: String) {
        Task {
            do {
                self.signUpStatus = .initiated
                try await firebaseUserAuthentication.signUp(withEmail: email, password: password)
                onSignUpSuccess()
            } catch let error as FirebaseAuthError {
                onSignUpFailure(alertMessage: error.localisedDescription)
            } catch {
                onSignUpFailure(alertMessage: error.localizedDescription)
            }
        }
    }
    
    func validateFirstName(firstName: String) {
        self.firstNameSatisfied = InputValidation.isValidFirstName(firstName: firstName)
    }
    
    func validateLastName(lastName: String) {
        self.lastNameSatisfied = InputValidation.isValidLastName(lastName: lastName)
    }
    
    func validateEmailFormat(email: String) {
        self.emailFormatSatisfied = InputValidation.isValidEmailFormat(email: email)
    }
    
    func validatePassword(password: String) {
        self.passwordRequirementCharacterCountSatisfied = InputValidation.isValidPasswordCharacterCount(password: password)
        self.passwordRequirementUppercaseCharacterSatisfied = InputValidation.isValidPasswordUpperCaseCharacter(password: password)
        self.passwordRequirementLowercaseCharacterSatisfied = InputValidation.isValidPasswordLowerCaseCharacter(password: password)
        self.passwordRequirementNumberSatisfied = InputValidation.isValidPasswordNumberCharacter(password: password)
        self.passwordRequirementSpecialCharacterSatisfied = InputValidation.isValidPasswordSpecialCharacter(password: password)
    }
    
    func validateConfirmPasswords(password: String, confirmPassword: String) {
        passwordsMatch = InputValidation.isValidConfirmPasswords(password: password, confirmPassword: confirmPassword)
    }
    
    func shouldEnableSubmit() -> Bool {
        firstNameSatisfied
        && lastNameSatisfied
        && emailFormatSatisfied
        && passwordRequirementCharacterCountSatisfied
        && passwordRequirementUppercaseCharacterSatisfied
        && passwordRequirementLowercaseCharacterSatisfied
        && passwordRequirementNumberSatisfied
        && passwordRequirementSpecialCharacterSatisfied
        && passwordsMatch
        && (signUpStatus == .reset || signUpStatus == .failure)
    }
    
    private func onSignUpSuccess() {
        self.signUpStatus = .success
        self.alertTitle = Constants.Alert.Title.signUpSuccess.rawValue.key
        self.alertMessage = Constants.Alert.Message.signUpSuccess.rawValue.key
    }
    
    private func onSignUpFailure(alertMessage: String) {
        self.alertTitle = Constants.Alert.Title.signUpFailed.rawValue.key
        self.alertMessage = alertMessage
        self.signUpStatus = .failure
    }
}
