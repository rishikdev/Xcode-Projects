//
//  InputValidation.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import Foundation

struct InputValidation {
    
    /// Checks if the provided first name is valid
    ///
    /// - Parameter firstName: First name provided by the user
    ///
    /// - Returns: Returns true if the `first name` is not empty.
    ///
    static func isValidFirstName(firstName: String) -> Bool {
        firstName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    /// Checks if the provided last name is valid
    ///
    /// - Parameter lastName: Last name provided by the user
    ///
    /// - Returns: Returns true if the `last name` is not empty.
    ///
    static func isValidLastName(lastName: String) -> Bool {
        lastName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    /// Checks if the provided email address is valid
    ///
    /// - Parameter email: Email address provided by the user
    ///
    /// - Returns: Returns true if the `email address` is formatted correctly.
    ///
    static func isValidEmailFormat(email: String) -> Bool {
        email.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 && email.lowercased().contains(/^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/)
    }
    
    /// Checks if the provided password is of appropriate length
    ///
    /// - Parameter password: Password provided by the user
    ///
    /// - Returns: Returns true if the `password's` character count (not including whitespaces) is within a certain range.
    ///
    static func isValidPasswordCharacterCount(password: String) -> Bool {
        password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 && password.count <= 4096
    }
    
    /// Checks if the provided password has at least one uppercase character
    ///
    /// - Parameter password: Password provided by the user
    ///
    /// - Returns: Returns true if the `password` has at least one uppercase character.
    ///
    static func isValidPasswordUpperCaseCharacter(password: String) -> Bool {
        password.contains(/[A-Z]/)
    }
    
    /// Checks if the provided password has at least one lowercase character
    ///
    /// - Parameter password: Password provided by the user
    ///
    /// - Returns: Returns true if the `password` has at least one lowercase character.
    ///
    static func isValidPasswordLowerCaseCharacter(password: String) -> Bool {
        password.contains(/[a-z]/)
    }
    
    /// Checks if the provided password has at least one numeric character
    ///
    /// - Parameter password: Password provided by the user
    ///
    /// - Returns: Returns true if the `password` has at least one numeric character.
    ///
    static func isValidPasswordNumberCharacter(password: String) -> Bool {
        password.contains(/[0-9]/)
    }
    
    /// Checks if the provided password has at least one special character
    ///
    /// - Parameter password: Password provided by the user
    ///
    /// - Returns: Returns true if the `password` has at least one special character.
    ///
    /// - Note: The *special characters* can be one or more of the following: ^ $ * . [ ] { } ( ) ? " ! @ # % & / \ , > < ' : ; | _ ~
    ///
    static func isValidPasswordSpecialCharacter(password: String) -> Bool {
        password.contains(/[\!\@\#\$\%\^\&\*\(\)\-\+=\{\}\[\]\|;:\'\"\,\.\<\>\/\?]/)
    }
    
    /// Checks if the provided password and confirmPassword are the same
    ///
    /// - Parameters:
    ///   - password: Password provided by the user
    ///   - confirmPassword: Confirmation password provided by the user
    ///
    /// - Returns: Returns true if  `password` and `confirmPassword` are the same.
    ///
    static func isValidConfirmPasswords(password: String, confirmPassword: String) -> Bool {
        password == confirmPassword
    }
}
