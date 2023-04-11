//
//  Constants.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 28/02/23.
//

import Foundation

struct Constants {
    
    // MARK: View Controller Titles
    struct VCTitles {
        static let onboardingVCTitle = "onboardingVCTitle".localized()
        static let signUpVCTitle = "signUpVCTitle".localized()
        static let homeTabVCTitle = "homeTabVCTitle".localized()
        static let exploreTabVCTitle = "exploreTabVCTitle".localized()
        static let messagesTabVCTitle = "messagesTabVCTitle".localized()
        static let settingsTabVC = "settingsTabVC".localized()
        static let createPostVC = "createPostVC".localized()
    }
    
    // MARK: - Label Texts
    struct LabelTexts {
        static let email = "email".localized()
        static let password = "password".localized()
        static let firstName = "firstName".localized()
        static let middleName = "middleName".localized()
        static let lastName = "lastName".localized()
        static let gender = "gender".localized()
        static let phoneNumber = "phoneNumber".localized()
        static let age = "age".localized()
        static let dateOfBirth = "dateOfBirth".localized()
        static let city = "city".localized()
        static let state = "state".localized()
        static let country = "country".localized()
        static let noContent = "noContent".localized()
        static let noFriends = "noFriends".localized()
        static let noMessages = "noMessages".localized()
        static let labelPosts = "labelPosts".localized()
        static let labelFollowers = "labelFollowers".localized()
        static let labelFollowing = "labelFollowing".localized()
        static let labelYourPosts = "labelYourPosts".localized()
        static let labelNoPosts = "labelNoPosts".localized()
        static let labelPostError = "labelPostError".localized()
    }
    
    // MARK: - Text Field Placeholders
    struct TextFieldPlaceholders {
        static let email = "email".localized()
        static let password = "password".localized()
        static let confirmPassword = "confirmPassword".localized()
        static let firstName = "firstName".localized()
        static let middleName = "middleName".localized()
        static let lastName = "lastName".localized()
        static let phoneNumber = "phoneNumber".localized()
        static let city = "city".localized()
        static let state = "state".localized()
        static let country = "country".localized()
    }
    
    // MARK: Tab Bar Titles
    struct TabBarTitles {
        static let homeTab = "homeTab".localized()
        static let exploreTab = "friendsTab".localized()
        static let messagesTab = "messagesTab".localized()
        static let settingsTab = "settingsTab".localized()
    }
    
    // MARK: Alerts
    struct Alerts {
        struct Titles {
            static let successful = "successful".localized()
            static let unsuccessful = "unsuccessful".localized()
            static let confirmation = "confirmation".localized()
        }
        
        struct Messages {
            static let firstName = "alertFirstName".localized()
            static let lastName = "alertLastName".localized()
            static let gender = "alertGender".localized()
            static let passwordMismatch = "alertPasswordMismatch".localized()
            static let phoneNumber = "alertPhoneNumber".localized()
            static let dateOfBirth = "alertDateOfBirth".localized()
            static let city = "alertCity".localized()
            static let state = "alertState".localized()
            static let country = "alertCountry".localized()
            static let loginWithDifferentProvider = "loginWithDifferentProvider".localized()
            static let successfulSignUp = "successfulSignUp".localized()
            static let unsuccessfulSignUpWrongEmailPassword = "unsuccessfulSignUpWrongEmailPassword".localized()
            static let unsuccessfulSignUpUserAlreadyExists = "unsuccessfulSignUpUserAlreadyExists".localized()
            static let unsuccessfulSignUpUserUnknown = "unsuccessfulSignUpUserUnknown".localized()
            static let successfulProfileCreation = "successfulProfileCreation".localized()
            static let successfulProfileUpdation = "successfulProfileUpdation".localized()
            static let unsuccessfulProfileCreation = "unsuccessfulProfileCreation".localized()
            static let unsuccessfulProfileUpdation = "unsuccessfulProfileUpdation".localized()
            static let successfulSignUpUnsuccessfulProfileCreation = "successfulSignUpUnsuccessfulProfileCreation".localized()
            static let successfulSignIn = "successfulSignIn".localized()
            static let unsuccessfulSignIn = "unsuccessfulSignIn".localized()
            static let successfulSignOut = "successfulSignOut".localized()
            static let unsuccessfulSignOut = "unsuccessfulSignOut".localized()
            static let completeProfileUponSuccessfulSignUpUsingProvider = "completeProfileUponSuccessfulSignUpUsingProvider".localized()
            static let signOutMessage = "signOutMessage".localized()
            static let successfulProfilePhotoUpload = "successfulProfilePhotoUpload".localized()
            static let unsuccessfulProfilePhotoUpload = "unsuccessfulProfilePhotoUpload".localized()
            static let successfulPostUpload = "successfulPostUpload".localized()
            static let unsuccessfulPostUpload = "unsuccessfulPostUpload".localized()
            static let successfulProfileCreationUnsuccessfulProfilePhotoUpload = "successfulProfileCreationUnsuccessfulProfilePhotoUpload".localized()
            static let successfulProfileUpdationUnsuccessfulProfilePhotoUpload = "successfulProfileUpdationUnsuccessfulProfilePhotoUpload".localized()
            static let successfulPostFetch = "successfulPostFetch".localized()
            static let unsuccessfulPostFetch = "unsuccessfulPostFetch".localized()
        }
    }
    
    // MARK: GendersString
    struct GendersString {
        static let male = "male".localized()
        static let female = "female".localized()
        static let other = "other".localized()
    }
    
    // MARK: GendersEnum
    enum Genders: String {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    // MARK: Providers
    struct Providers {
        static let google = "google.com".localized()
        static let facebook = "facebook.com".localized()
        static let emailPassword = "password".localized()
        static let noProvider = "".localized()
    }
    
    // MARK: Errors
    struct Errors {
        static let operationTerminatedByTheUser = "operationTerminatedByTheUser".localized()
    }
    
    // MARK: CoreData
    struct CoreData {
        static let container = "SocialifyMe"
        static let entityLocalUser = "LocalUser"
    }
    
    // MARK: ProfilePhoto
    struct ProfilePhoto {
        static let name = "profilePhoto"
        static let extn = ".jpeg"
    }
    
    // MARK: Buttons
    struct Buttons {
        static let signIn = "buttonSignIn".localized()
        static let signUp = "buttonSignUp".localized()
        static let signInWithGoogle = "buttonSignInWithGoogle".localized()
        static let signInWithFacebook = "buttonSignInWithFacebook".localized()
        static let ok = "buttonOk".localized()
        static let yesSure = "buttonYesSure".localized()
        static let noMaybeLater = "buttonNoMaybeLater".localized()
        static let updateProfile = "buttonUpdateProfile".localized()
        static let signOut = "buttonSignOut".localized()
        static let cancel = "buttonCancel".localized()
        static let save = "buttonSave".localized()
        static let gender = "buttonGender".localized()
        static let editProfile = "buttonEditProfile".localized()
        static let selectPhoto = "buttonSelectPhoto".localized()
        static let post = "buttonPost".localized()
    }
    
    // MARK: - Default URLs
    struct DefaultURLs {
        static let noProfilePhoto = "https://t4.ftcdn.net/jpg/00/97/00/09/360_F_97000908_wwH2goIihwrMoeV9QF3BW6HtpsVFaNVM.jpg"
        static let noPostPhoto = "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930"
    }
}
