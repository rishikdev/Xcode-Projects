//
//  ErrorMapping.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import Foundation
import FirebaseAuth

enum FirebaseAuthError: Error, LocalizedError {
    case invalidEmail
    case weakPassword
    case userAlreadyExists
    case userDisabled
    case networkError
    case invalidCredential
    case unknownError(String)
    
    var localisedDescription: String {
        switch self {
        case .invalidEmail:
            return Constants.Alert.Message.invalidEmail.rawValue.key
        case .weakPassword:
            return Constants.Alert.Message.weakPassword.rawValue.key
        case .userAlreadyExists:
            return Constants.Alert.Message.userAlreadyExists.rawValue.key
        case .userDisabled:
            return Constants.Alert.Message.userDisabled.rawValue.key
        case .invalidCredential:
            return Constants.Alert.Message.invalidCredential.rawValue.key
        case .networkError:
            return Constants.Alert.Message.networkError.rawValue.key
        case .unknownError(let message):
            return message
        }
    }
}

struct ErrorMapping {
    
    /// Converts `NSError` to `FirebaseAuthError`
    ///
    /// - Parameter error: Error of type `NSError`
    ///
    /// - Returns: Returns `FirebaseAuthError` corresponding to the `NSError` provided.
    ///
    static func mapFirebaseError(_ error: NSError) -> FirebaseAuthError {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .userAlreadyExists
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        case AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredential
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknownError(error.localizedDescription)
        }
    }
}
