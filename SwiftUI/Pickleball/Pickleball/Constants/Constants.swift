//
//  Constants.swift
//  Pickleball
//
//  Created by Rishik Dev on 05/11/24.
//

import Foundation

enum Constants {
    enum Text: LocalizedStringResource {
        case brandName = "Pickleball"
        case firstName = "First Name"
        case middleName = "Middle Name"
        case lastName = "Last Name"
        case dateOfBirth = "Date of Birth"
        case email = "Email"
        case password = "Password"
        case confirmPassword = "Confirm Password"
        case emailFormatShouldBeValid = "Email address' format should be valid. Example: example@domain.com"
        case emailFormatValid = "Valid email address format"
        case emailFormatInvalid = "Invalid email address format. Email address' format should be valid. Example: example@domain.com"
        case passwordRequirements = "Password must meet the following requirements:"
        case passwordRequirementCharacterCount = "Have between 8 and 4096 characters"
        case passwordRequirementUppercaseCharacter = "Contain at least one uppercase letter"
        case passwordRequirementLowercaseCharacter = "Contain at least one lowercase letter"
        case passwordRequirementNumber = "Contain at least one number"
        case passwordRequirementSpecialCharacter = "Contain at least one special character ^ $ * . [ ] { } ( ) ? \" ! @ # % & / \\ , > < ' : ; | _ ~"
        case passwordsShouldMatch = "Passwords should match"
        case passwordsMatch = "Passwords match"
        case passwordsDoNotMatch = "Passwords do not match"
        case required = "Required"
        case loading = "Loading"
        case or = "OR"
    }
    
    enum ViewTitle: LocalizedStringResource {
        case clubs = "Clubs"
        case dashboard = "Dashboard"
        case profile = "Profile"
        case settings = "Settings"
        case tournaments = "Tournaments"
        case signIn = "Sign In"
        case signUp = "Sign Up"
    }
    
    enum ButtonText: LocalizedStringResource {
        case cancel = "Cancel"
        case dismiss = "Dismiss"
        case deleteAccount = "Delete Account"
        case signIn = "Sign In"
        case signOut = "Sign Out"
        case signInWithApple = "Sign In with Apple"
        case signInWithEmail = "Sign In with Email"
        case signInWithGoogle = "Sign In with Google"
        case signUp = "Don't have an account? Sign Up"
        case submit = "Submit"
    }
    
    enum ProgressViewText: LocalizedStringResource {
        case creatingProfile = "Creating Profile"
        case signingIn = "Signing In"
        case signingOut = "Signing Out"
        case signingUp = "Signing Up"
    }
    
    enum Alert {
        enum Title: LocalizedStringResource {
            case accountCouldNotBeCreated = "Account Could Not Be Created"
            case error = "Error"
            case signInFailed = "Sign In Failed"
            case signInSuccess = "Sign In Successful"
            case signOutFailed = "Sign Out Failed"
            case signOutSuccess = "Sign Out Successful"
            case signUpFailed = "Sign Up Failed"
            case signUpSuccess = "Sign Up Successful"
        }
        
        enum Message: LocalizedStringResource {
            case invalidEmail = "The email address is badly formatted."
            case weakPassword = "The password is too weak."
            case userAlreadyExists = "An account already exists with this email."
            case userDisabled = "This account is disabled."
            case networkError = "Network error, please try again."
            case invalidCredential = "This combination of email and password does not exist. Please check your credentials and try again."
            case unknownError = "Unknown Error Occurred."
            case signUpSuccess = "Your account has been successfully created. You will now be signed in with the email address and password you provided."
            case signInWithGoogleCouldNotBePresented = "Google Sign In page could not be presented."
        }
    }
    
    enum UserDefaults: String {
        case isSignedIn = "isSignedIn"
    }
    
    enum ImageSize: CGFloat {
        case height = 250
        case width = 200
    }
    
    enum Spacing: CGFloat {
        case small = 10
        case medium = 20
        case large = 30
    }
    
    enum CornerRadius: CGFloat {
        case small = 10
        case medium = 20
        case large = 30
    }
}
