//
//  SignedInHomeViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 08/03/23.
//

import UIKit

/// `ViewModel` class for ``OnboardingViewController``.
///
/// - Handles functionalities related to **signing users in** using `Email + Password`, `Google`, and `Facebook`.
///
/// - Properties:
///     - ``firebaseAuthenticationManager``
///     - ``firebaseStorageManager``
///     - ``firebaseRealtimeDatabaseManager``
///     - ``coreDataManager``
///
/// - Functions:
///     - ``signInWithEmailPassword(email:password:completion:)``
///     - ``signInWithGoogle(currentViewController:completion:)``
///     - ``signInWithFacebook(currentViewController:completion:)``
///     - ``createUserProfileInFirebaseDatabase(userModel:completion:)``
///
class OnboardingViewModel {
    
    var firebaseAuthenticationManager: FirebaseAuthenticationManagerProtocol
    var firebaseStorageManager: FirebaseStorageManagerProtocol
    var firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol
    var coreDataManager: CoreDataManagerProtocol
    
    init(firebaseAuthenticationManager: FirebaseAuthenticationManagerProtocol, firebaseStorageManager: FirebaseStorageManagerProtocol, firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firebaseStorageManager = firebaseStorageManager
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Sign In With Email And Password
    /// Signs users in using their email address and password.
    ///
    /// - Calls ``FirebaseAuthenticationManager/signInWithEmailPassword(email:password:completion:)`` function.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///
    /// - Parameters:
    ///   - email: The email address of the user
    ///   - password: The password of the user
    ///   - completion: An escaping closure with two arguments
    ///
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool) -> Void) {
        firebaseAuthenticationManager.signInWithEmailPassword(email: email, password: password) { signInMessage, isSignInSuccessful, userModel in
            if(isSignInSuccessful) {
                self.firebaseStorageManager.downloadProfilePhotoFromFirebaseStorage(uid: userModel!.uid) { downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                    DispatchQueue.main.async {
                        if(isProfilePhotoDownloaded) {
                            self.coreDataManager.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: downloadedProfilePhotoURL)
                        } else {
                            self.coreDataManager.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: nil)
                        }
                        SharedUser.shared.localUser = self.coreDataManager.fetchLocalUsers()[0]
                        
                        completion(signInMessage, isSignInSuccessful)
                    }
                }
            } else {
                completion(signInMessage, isSignInSuccessful)
            }
        }
    }
    
    // MARK: - Sign In With Google
    /// Signs users in using their Google credentials.
    ///
    /// - Calls ``FirebaseAuthenticationManager/signInWithGoogle(withPresenting:completion:)`` function.
    /// - The parameter 'completion' has three arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - currentViewController: The view controller calling this function
    ///   - completion: An escaping closure with three arguments
    ///
    func signInWithGoogle(currentViewController: UIViewController, completion: @escaping (String, Bool, Bool) -> Void) {
        firebaseAuthenticationManager.signInWithGoogle(withPresenting: currentViewController) { signInMessage, isSignInSuccessful, userModel, isNewUser in
            if(isSignInSuccessful) {
                self.firebaseStorageManager.downloadProfilePhotoFromFirebaseStorage(uid: userModel!.uid) { downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                    DispatchQueue.main.async {
                        if(isProfilePhotoDownloaded) {
                            self.coreDataManager.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: downloadedProfilePhotoURL)
                        } else {
                            self.coreDataManager.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: nil)
                        }
                        SharedUser.shared.localUser = self.coreDataManager.fetchLocalUsers()[0]
                        
                        completion(signInMessage, isSignInSuccessful, isNewUser)
                    }
                }
            } else {
                completion(signInMessage, isSignInSuccessful, isNewUser)
            }
        }
    }
    
    // MARK: - Sign In With Facebook
    /// Signs users in using their Facebook credentials.
    ///
    ///  - Calls ``FirebaseAuthenticationManager/signInWithFacebook(viewController:completion:)`` function.
    ///  - The parameter 'completion' has three arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     4. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - currentViewController: The view controller calling this function
    ///   - completion: An escaping closure with three arguments
    ///
    func signInWithFacebook(currentViewController: UIViewController, completion: @escaping (String, Bool, Bool) -> Void) {
        firebaseAuthenticationManager.signInWithFacebook(viewController: currentViewController) { signInMessage, isSignInSuccessful, userModel, isNewUser in
            if(isSignInSuccessful) {
                self.firebaseStorageManager.downloadProfilePhotoFromFirebaseStorage(uid: userModel!.uid) { downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                    DispatchQueue.main.async {
                        if(isProfilePhotoDownloaded) {
                            self.coreDataManager.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: downloadedProfilePhotoURL)
                        } else {
                            self.coreDataManager.createUserProfileInLocalStorage(userModel: userModel!, profilePhotoLocalStorageURL: nil)
                        }
                        SharedUser.shared.localUser = self.coreDataManager.fetchLocalUsers()[0]
                        completion(signInMessage, true, isNewUser)
                    }
                }
            } else {
                completion(signInMessage, false, isNewUser)
            }
        }
    }
    
    // MARK: - Create User Profile In Firebase Database
    /// Creates user's profile in Firebase Realtime Database
    ///
    /// - Creates a `UserModel` object and converts it to a dictionary.
    /// - Calls ``FirebaseRealtimeDatabaseManager/createUserProfileInFirebaseDatabase(uid:userDictionary:completion:)`` function.
    /// - If the users sign up using **Email and Password**, their profile is created using the information obtained from the sign up page.
    /// - If the users sign up using **Google**, their profile is created using their`first name` and `last name` obtained from Google.
    /// - If the users sign up using **Facebook**, their profile is created using their`first name`, `middle name` and `last name` obtained from Facebook.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully created in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile creation failed.
    ///     2. `Bool`: Indicating whether the profile was created or not.
    ///
    /// - Parameters:
    ///   - user: An object of type `UserModel`
    ///   - completion: An escaping closure with two arguments
    ///
    func createUserProfileInFirebaseDatabase(userModel: UserModel, completion: @escaping (String, Bool) -> Void) {
        let userDictionary = HelperFunctions.shared.getUserDictionary(userModel: userModel)
        firebaseRealtimeDatabaseManager.createUserProfileInFirebaseDatabase(uid: userModel.uid, userDictionary: userDictionary) { message, isProfileCreated in completion(message, isProfileCreated) }
    }
}
