//
//  ConfirmPasswordInputView.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import SwiftUI

struct ConfirmPasswordInputView: View {
    @Binding var confirmPassword: String
    var passwordsMatch: Bool
    var onConfirmPasswordChange: (String) -> Void
    
    @State private var inputFieldType: InputFieldType = .secure
    
    private let defaultInputFieldStatusImage = Image(systemName: "info.circle")
    private let satisfiedInputFieldStatusImage = Image(systemName: "checkmark.circle")
    private let unsatisfiedInputFieldStatusImage = Image(systemName: "xmark.circle")
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small.rawValue) {
            InputFieldView(text: $confirmPassword,
                           inputFieldType: $inputFieldType,
                           placeholder: Constants.Text.confirmPassword.rawValue,
                           header: Text(Constants.Text.confirmPassword.rawValue),
                           footer: confirmPasswordRequirementsFooter,
                           showEye: true)
            .onChange(of: confirmPassword) { confirmPassword in
                onConfirmPasswordChange(confirmPassword)
            }
        }
    }
    
    var confirmPasswordRequirementsFooter: some View {
        RequirementsTextView(statusImage: confirmPassword.count == 0 ? defaultInputFieldStatusImage : passwordsMatch ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                        text: confirmPassword.count == 0 ? Constants.Text.passwordsShouldMatch.rawValue : passwordsMatch ? Constants.Text.passwordsMatch.rawValue : Constants.Text.passwordsDoNotMatch.rawValue ,
                        foregroundColour: confirmPassword.count == 0 ? .gray : passwordsMatch ? .green : .red)
    }
}

#Preview {
    ConfirmPasswordInputView(confirmPassword: .constant(""),
                             passwordsMatch: false,
                             onConfirmPasswordChange: {_ in})
}
