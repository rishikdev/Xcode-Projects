//
//  BasicDetailsInputView.swift
//  Pickleball
//
//  Created by Rishik Dev on 18/11/24.
//

import SwiftUI

struct BasicDetailsInputView: View {
    @Binding var firstName: String
    @Binding var middleName: String
    @Binding var lastName: String
    @Binding var dateOfBirth: Date
    var firstNameSatisfied: Bool
    var lastNameSatisfied: Bool
    var onFirstNameChange: (String) -> Void
    var onLastNameChange: (String) -> Void
    
    private let datePickerStartDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
    private let datePickerEndDate = Date.now
    private let defaultInputFieldStatusImage = Image(systemName: "info.circle")
    private let satisfiedInputFieldStatusImage = Image(systemName: "checkmark.circle")
    private let unsatisfiedInputFieldStatusImage = Image(systemName: "xmark.circle")
    
    var body: some View {
        VStack(spacing: Constants.Spacing.small.rawValue) {
            InputFieldView(text: $firstName,
                           inputFieldType: .constant(.regular),
                           placeholder: Constants.Text.firstName.rawValue,
                           header: Text(Constants.Text.firstName.rawValue),
                           footer: firstNameRequirementsFooter
            )
            .onChange(of: firstName) { firstName in
                onFirstNameChange(firstName)
            }
            
            InputFieldView<Text, EmptyView>(text: $middleName,
                                            inputFieldType: .constant(.regular),
                                            placeholder: Constants.Text.middleName.rawValue,
                                            header: Text(Constants.Text.middleName.rawValue))
            
            InputFieldView(text: $lastName,
                           inputFieldType: .constant(.regular),
                           placeholder: Constants.Text.lastName.rawValue,
                           header: Text(Constants.Text.lastName.rawValue),
                           footer: lastNameRequirementsFooter)
            .onChange(of: lastName) { lastName in
                onLastNameChange(lastName)
            }
            
            DatePicker(selection: $dateOfBirth,
                       in: datePickerStartDate...datePickerEndDate,
                       displayedComponents: .date) {
                VStack(alignment: .leading) {
                    Text(Constants.Text.dateOfBirth.rawValue)
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    dateOfBirthRequirementsFooter
                }
            }
        }
    }
    
    var firstNameRequirementsFooter: some View {
        RequirementsTextView(statusImage: firstName.isEmpty ? defaultInputFieldStatusImage : firstNameSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                             text: Constants.Text.required.rawValue,
                             foregroundColour: firstName.isEmpty ? .gray : firstNameSatisfied ? .green : .red)
    }
    
    var lastNameRequirementsFooter: some View {
        RequirementsTextView(statusImage: lastName.isEmpty ? defaultInputFieldStatusImage : lastNameSatisfied ? satisfiedInputFieldStatusImage : unsatisfiedInputFieldStatusImage,
                             text: Constants.Text.required.rawValue,
                             foregroundColour: lastName.isEmpty ? .gray : lastNameSatisfied ? .green : .red)
    }
    
    var dateOfBirthRequirementsFooter: some View {
        RequirementsTextView(statusImage: defaultInputFieldStatusImage,
                             text: Constants.Text.required.rawValue,
                             foregroundColour: .gray)
    }
}

#Preview {
    BasicDetailsInputView(firstName: .constant(""),
                          middleName: .constant(""),
                          lastName: .constant(""),
                          dateOfBirth: .constant(.now),
                          firstNameSatisfied: false,
                          lastNameSatisfied: false,
                          onFirstNameChange: {_ in },
                          onLastNameChange: {_ in})
}
