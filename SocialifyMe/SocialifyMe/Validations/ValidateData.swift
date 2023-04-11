//
//  ValidateTextField.swift
//  SignUp
//
//  Created by Rishik Dev on 21/02/23.
//

import Foundation

class ValidateData {
    
    static let shared = ValidateData()
    private init() {}
    
    func isValidFirstName(value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
    
    func isValidLastName(value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
    
    func isValidGender(value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
    
    func arePasswordsMatching(password: String, confirmedPassword: String) -> Bool {
        password == confirmedPassword
    }
    
    func isValidPhoneNumber(value: String) -> Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value)) && (value.trimmingCharacters(in: .whitespacesAndNewlines).count == 10 || value.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
    }
    
    func isValidDateOfBirth(value: Date) -> (Bool, Int?) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: value, to: Date.now)
        
        return ((components.year ?? 0) > 0, components.year)
    }
    
    func isValidCity(value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
    
    func isValidState(value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
    
    func isValidCountry(value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
}
