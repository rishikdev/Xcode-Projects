//
//  UserViewModel.swift
//  SignUp
//
//  Created by Rishik Dev on 21/02/23.
//

import Foundation
import FirebaseAuth

/// `ViewModel` class for ``SignUpViewController`` and ``EditProfileViewController``
///
/// - Handles functionalities related to **creating user profiles**.
///
/// - Properties:
///     - ``firebaseAuthenticationManager``
///     - ``firebaseStorageManager``
///     - ``firebaseRealtimeDatabaseManager``
///     - ``coreDataManager``
///
/// - Functions:
///     - ``createUserProfileInFirebaseDatabase(userModel:completion:)``
///     - ``updateUserProfileInFirebaseDatabase(userModel:completion:)``
///     - ``uploadProfilePhotoToFirebaseStorage(uid:from:completion:)``
///     - ``downloadProfilePhotoFromFirebaseStorage(uid:completion:)``
///     - ``createAccount(email:password:completion:)``
///     - ``fetchUserProfilesFromLocalStorage()``
///     - ``createUserProfileInLocalStorage(userModel:profilePhotoURL:)``
///     - ``updateUserProfileInLocalStorage(localUser:updatedUserModel:profilePhotoURL:)``
///
class EditProfileViewModel {
    
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
    
    // MARK: - Firebase Realtime Database Functions
    
    // MARK: Create User Profile In Firebase Database
    /// Creates user's profile in Firebase Realtime Database
    ///
    /// - Creates a ``UserModel`` object and converts it to a dictionary.
    /// - Calls ``FirebaseRealtimeDatabaseManager/createUserProfileInFirebaseDatabase(uid:userDictionary:completion:)`` function.
    /// - If the users sign up using **Email and Password**, their profile is created using the information obtained from the sign up page.
    /// - If the users sign up using **Google**, their profile is created using their`first name` and `last name` obtained from Google.
    /// - If the users sign up using **Facebook**, their profile is created using their`first name`, `middle name` and `last name` obtained from Facebook.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully created in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile creation failed.
    ///     2. `Bool`: Indicating whether the profile was created or not.
    ///
    /// - Parameters:
    ///   - user: An object of type `UserModel`.
    ///   - completion: An escaping closure with two arguments.
    ///
    func createUserProfileInFirebaseDatabase(userModel: UserModel, completion: @escaping (String, Bool) -> Void) {
        let userDictionary = HelperFunctions.shared.getUserDictionary(userModel: userModel)
        firebaseRealtimeDatabaseManager.createUserProfileInFirebaseDatabase(uid: userModel.uid, userDictionary: userDictionary) { message, isProfileCreated in completion(message, isProfileCreated) }
    }
    
    // MARK: Update User Profile In Firebase Database
    /// Updates user's profile in Firebase Realtime Database
    ///
    /// - Creates a ``UserModel`` object and converts it into a dictionary.
    /// - Calls ``FirebaseRealtimeDatabaseManager/updateUserProfileInFirebaseDatabase(uid:userDictionary:completion:)`` function.
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the profile was successfully updated in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile updation failed.
    ///     2. `Bool`: Indicating whether the profile was updated or not.
    ///     3. `UserModel`: An object of type `UserModel` with the updated information.
    ///
    /// - Parameters:
    ///   - user: An object of type `UserModel`.
    ///   - completion: An escaping closure with two arguments.
    ///
    func updateUserProfileInFirebaseDatabase(userModel: UserModel, completion: @escaping (String, Bool, UserModel) -> Void) {
        let userDictionary = HelperFunctions.shared.getUserDictionary(userModel: userModel)
        firebaseRealtimeDatabaseManager.updateUserProfileInFirebaseDatabase(uid: userModel.uid, userDictionary: userDictionary) { message, isProfileCreated in completion(message, isProfileCreated, userModel) }
    }
    
    // MARK: - Firebase Storage Funcions

    //MARK: Upload Profile Photo to Firebase Storage
    /// Uploads user's profile photo to Firebase Storage.
    ///
    /// - Calls ``FirebaseStorageManager/uploadProfilePhotoToFirebaseStorage(uid:from:completion:)`` function.
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains the reason why the upload failed.
    ///     2. `String`: If the upload was successful, this argument contains the download URL of the photo, Otherwise, it is nil.
    ///     3. `Bool`: Indicating whether the profile photo was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - urlPath: Local storage URL of profile photo.
    ///   - completion: An escaping closure with three arguments.
    ///
    func uploadProfilePhotoToFirebaseStorage(uid: String, from urlPath: URL, completion: @escaping (String, String?, Bool) -> Void) {
        firebaseStorageManager.uploadProfilePhotoToFirebaseStorage(uid: uid, from: urlPath) { message, downloadURL, isProfilePhotoUploaded in completion (message, downloadURL, isProfilePhotoUploaded)}
    }
    
    // MARK: Download Profile Photo From Firebase Storage
    /// Downloads user's profile photo from Firebase Storage to local storage.
    ///
    /// - Calls ``FirebaseStorageManager/downloadProfilePhotoFromFirebaseStorage(uid:completion:)`` function.
    /// - The parameter `completion` has two arguments:
    ///     1. `URL?`: If the profile photo was downloaded successfully, this argument contains the path of the downloaded profile photo. Otherwise, it is nil.
    ///     2. `Bool`: Indicating whether the profile photo was downloaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - completion: An escaping closure with two arguments.
    ///
    func downloadProfilePhotoFromFirebaseStorage(uid: String, completion: @escaping (URL?, Bool) -> Void) {
        firebaseStorageManager.downloadProfilePhotoFromFirebaseStorage(uid: uid) { downloadedProfilePhotoURL, isProfileDownloaded in completion(downloadedProfilePhotoURL, isProfileDownloaded) }
    }
    
    // MARK: - Firebase Authentication Functions
    
    // MARK: Create Account
    /// Creates user's account on `Firebase`
    ///
    /// - Calls ``FirebaseAuthenticationManager/createAccount(email:password:completion:)`` function.
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the account creation was successful, this argument contains a success message. Otherwise, it contains the reason why the account creation failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `User?`: If the account creation was successful, this argument has an object of type User. Otherwise, it is nil.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - password: Password of the user.
    ///   - completion: An escaping closure with three arguments.
    ///
    func createAccount(email: String, password: String, completion: @escaping (String, Bool, User?) -> Void) {
        firebaseAuthenticationManager.createAccount(email: email, password: password) { message, isAccountCreated, user in completion(message, isAccountCreated, user) }
    }
    
    // MARK: - Core Data Functions
    
    // MARK: Fetch User Profiles From Local Storage
    /// Fetches an array of LocalUsers
    ///
    ///  Calls ``CoreDataManager/fetchLocalUsers()`` function.
    ///
    /// - Returns: An array of `LocalUser` objects.
    ///
    /// - Note: There will be only one object of `LocalUser` in storage at any given time.
    ///
    func fetchUserProfilesFromLocalStorage() -> [LocalUser] {
        coreDataManager.fetchLocalUsers()
    }
    
    // MARK: Create User Profile In Local Storage
    /// Persists user's information to local storage.
    ///
    /// - First deletes the previous `LocalUser` object stored on device. This is achieved by calling ``CoreDataManager/deleteAllLocalUsers(entity:)`` function.
    /// - Then calls ``CoreDataManager/createUserProfileInLocalStorage(userModel:profilePhotoURL:)`` function.
    /// - Finally, stores a `LocalUser` object in memory by calling ``CoreDataManager/fetchLocalUsers()`` function.
    ///
    /// - Parameters:
    ///   - userModel: An object of type `UserModel` to be stored in local storage.
    ///   - profilePhotoURL: An optional `URL` pointing to the device's local storage where the user's profile photo is stored.
    ///
    /// - Note: `profilePhotoURL` will be nil if the user does not have a profile photo.
    ///
    func createUserProfileInLocalStorage(userModel: UserModel, profilePhotoURL: URL?) {
        // Deleting the previous user's information
        coreDataManager.deleteAllLocalUsers(entity: Constants.CoreData.entityLocalUser)
        
        // Adding a new user
        coreDataManager.createUserProfileInLocalStorage(userModel: userModel, profilePhotoLocalStorageURL: profilePhotoURL)
        
        SharedUser.shared.localUser = coreDataManager.fetchLocalUsers()[0]
    }
    
    // MARK: Update User Profile In Local Storage
    /// Updates and persists user's information to local storage.
    ///
    /// - Calls ``CoreDataManager/updateUserProfileInLocalStorage(localUser:updatedUserModel:profilePhotoURL:)`` function.
    /// - Then, stores a `LocalUser` object in memory by calling ``CoreDataManager/fetchLocalUsers()`` function.
    ///
    /// - Parameters:
    ///   - localUser: An object of type `LocalUser` which is to be updated.
    ///   - updatedUserModel: An object of type `UserModel` with updated information.
    ///   - profilePhotoURL: An optional `URL` pointing to the device's local storage where the user's profile photo is stored.
    ///
    /// - Note: `profilePhotoURL` will be nil if the user does not have a profile photo.
    ///
    func updateUserProfileInLocalStorage(localUser: LocalUser, updatedUserModel: UserModel, profilePhotoURL: URL?) {
        coreDataManager.updateUserProfileInLocalStorage(localUser: localUser, updatedUserModel: updatedUserModel, profilePhotoURL: profilePhotoURL)
        
        SharedUser.shared.localUser = coreDataManager.fetchLocalUsers()[0]
    }
}
