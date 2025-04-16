//
//  PasswordInputView.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import SwiftUI

struct PasswordInputView: View {
    @Binding var password: String
    var passwordRequirementCharacterCountSatisfied: Bool
    var passwordRequirementUppercaseCharacterSatisfied: Bool
    var passwordRequirementLowercaseCharacterSatisfied: Bool
    var passwordRequirementNumberSatisfied: Bool
    var passwordRequirementSpecialCharacterSatisfied: Bool
    var passwordsMatch: Bool
    var onPasswordChange: (String) -> Void
    
    @State private var inputFieldType: InputFieldType = .secure
    @State private var isDisclosureGroupExpanded: Bool = true
    
    private let defaultInputFieldStatusImage = Image(systemName: "info.circle")
    private let satisfiedInputFieldStatusImage = Image(systemName: "checkmark.circle")
    private let unsatisfiedInputFieldStatusImage = Image(systemName: "xmark.circle")
    
    var body: some View {
        VStack(spacing: Constants.Spacing.small.rawValue) {
            InputFieldView(text: $password,
                           inputFieldType: $inputFieldType,
                           placeholder: Constants.Text.password.rawValue,
                           header: Text(Constants.Text.password.rawValue),
                           footer: passwordRequirementsFooter,
                           showEye: true)
            .onChange(of: password) { password in
                onPasswordChange(password)
            }
        }
    }
    
    var passwordRequirementsFooter: some View {
        DisclosureGroup(Constants.Text.passwordRequirements.rawValue.key,
                        isExpanded: $isDisclosureGroupExpanded) {
            VStack(alignment: .leading) {
                RequirementsTextView(statusImage: password.count == 0 ? defaultInputFieldStatusImage : passwordRequirementCharacterCountSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                                     text: Constants.Text.passwordRequirementCharacterCount.rawValue,
                                     foregroundColour: password.count == 0 ? .gray : passwordRequirementCharacterCountSatisfied ? .green : .red)
                
                RequirementsTextView(statusImage: password.count == 0 ? defaultInputFieldStatusImage : passwordRequirementUppercaseCharacterSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                                text: Constants.Text.passwordRequirementUppercaseCharacter.rawValue,
                                foregroundColour: password.count == 0 ? .gray : passwordRequirementUppercaseCharacterSatisfied ? .green : .red)
                
                RequirementsTextView(statusImage: password.count == 0 ? defaultInputFieldStatusImage : passwordRequirementLowercaseCharacterSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                                text: Constants.Text.passwordRequirementLowercaseCharacter.rawValue,
                                foregroundColour: password.count == 0 ? .gray : passwordRequirementLowercaseCharacterSatisfied ? .green : .red)
                
                RequirementsTextView(statusImage: password.count == 0 ? defaultInputFieldStatusImage : passwordRequirementNumberSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                                text: Constants.Text.passwordRequirementNumber.rawValue,
                                foregroundColour: password.count == 0 ? .gray : passwordRequirementNumberSatisfied ? .green : .red)
                
                RequirementsTextView(statusImage: password.count == 0 ? defaultInputFieldStatusImage : passwordRequirementSpecialCharacterSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                                text: Constants.Text.passwordRequirementSpecialCharacter.rawValue,
                                foregroundColour: password.count == 0 ? .gray : passwordRequirementSpecialCharacterSatisfied ? .green : .red)
            }
        }
                        .font(.caption)
                        .tint(.gray)
    }
}

#Preview {
    PasswordInputView(password: .constant(""),
                      passwordRequirementCharacterCountSatisfied: false,
                      passwordRequirementUppercaseCharacterSatisfied: false,
                      passwordRequirementLowercaseCharacterSatisfied: false,
                      passwordRequirementNumberSatisfied: false,
                      passwordRequirementSpecialCharacterSatisfied: false,
                      passwordsMatch: false,
                      onPasswordChange: {_ in})
}
