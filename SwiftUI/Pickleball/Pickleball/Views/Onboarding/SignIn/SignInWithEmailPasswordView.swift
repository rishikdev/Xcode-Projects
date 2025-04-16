//
//  SignInWithEmailPasswordView.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import SwiftUI

struct SignInWithEmailPasswordView: View {
    @Environment(\.colorScheme) private var colourScheme
    
    @ObservedObject var signInViewModel: SignInViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var inputFieldType: InputFieldType = .secure
    
    @State private var presentAlert: Bool = false
    
    var body: some View {
        VStack(spacing: Constants.Spacing.medium.rawValue) {
            EmailInputView(email: $email,
                           emailFormatSatisfied: signInViewModel.emailFormatSatisfied) { email in
                signInViewModel.validateEmailFormat(email: email)
            }
            
            InputFieldView<Text, EmptyView>(text: $password,
                                            inputFieldType: $inputFieldType,
                                            placeholder: Constants.Text.password.rawValue,
                                            header: Text(Constants.Text.password.rawValue),
                                            showEye: true)
            .onChange(of: password) { password in
                signInViewModel.validatePassword(password: password)
            }
            
            AuthenticationButtonView(text: Constants.ButtonText.signInWithEmail.rawValue,
                                     image: Image(systemName: "envelope.fill"),
                                     textColour: colourScheme == .light ? .white : .black,
                                     tint: colourScheme == .light ? .black : .white, action: { onLoginWithEmailSubmit() })
            .disabled(!signInViewModel.shouldEnableSubmit())
        }
        .roundGrayBackground()
        .textFieldStyle(.roundedBorder)
    }
    
    // MARK: - onSubmit()
    func onLoginWithEmailSubmit() {
        signInViewModel.signInWithEmail(email: email, password: password)
    }
    
}

#Preview {
    SignInWithEmailPasswordView(signInViewModel: .init(firebaseUserAuthentication: FirebaseUserAuthenticationManager.shared))
}
