//
//  EmailInputView.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import SwiftUI

struct EmailInputView: View {
    @Binding var email: String
    var emailFormatSatisfied: Bool
    var onEmailChange: (String) -> Void
    
    private let defaultInputFieldStatusImage = Image(systemName: "info.circle")
    private let satisfiedInputFieldStatusImage = Image(systemName: "checkmark.circle")
    private let unsatisfiedInputFieldStatusImage = Image(systemName: "xmark.circle")
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small.rawValue) {
            InputFieldView(text: $email,
                           inputFieldType: .constant(.regular),
                           placeholder: Constants.Text.email.rawValue,
                           header: Text(Constants.Text.email.rawValue),
                           footer: emailRequirementsFooter,
                           keyboardType: .emailAddress)
            .onChange(of: email) { email in
                withAnimation {
                    onEmailChange(email)
                }
            }
        }
    }
    
    var emailRequirementsFooter: some View {
        RequirementsTextView(statusImage: email.count == 0 ? defaultInputFieldStatusImage : emailFormatSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                        text: email.count == 0 ? Constants.Text.emailFormatShouldBeValid.rawValue : emailFormatSatisfied ? Constants.Text.emailFormatValid.rawValue : Constants.Text.emailFormatInvalid.rawValue ,
                        foregroundColour: email.count == 0 ? .gray : emailFormatSatisfied ? .green : .red)
    }
}

#Preview {
    EmailInputView(email: .constant(""),
                   emailFormatSatisfied: false,
                   onEmailChange: {_ in})
}
