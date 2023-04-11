//
//  FirebaseRealtimeDatabaseManagerProtocol.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import Foundation

protocol FirebaseRealtimeDatabaseManagerProtocol {
    /// Creates user's profile in **Firebase Realtime Database**.
    ///
    /// - If the users sign up using **Email and Password**, their profile is created using the information obtained from the sign up page.
    /// - If the users sign up using **Google**, their profile is created using their`first name` and `last name` obtained from Google.
    /// - If the users sign up using **Facebook**, their profile is created using their`first name`, `middle name` and `last name` obtained from Facebook.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully created in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile creation failed.
    ///     2. `Bool`: Indicating whether the profile was created or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - userDictionary: A `dictionary` with user's informaition.
    ///   - completion: An escaping closure with two arguments.
    ///
    func createUserProfileInFirebaseDatabase(uid: String, userDictionary: [String: Any], completion: @escaping (String, Bool) -> Void)
    
    /// Updates user's profile in **Firebase Realtime Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully updated in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile updation failed.
    ///     2. `Bool`: Indicating whether the profile was updated or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - user: A `dictionary` with user's informaition.
    ///   - completion: An escaping closure with two arguments.
    ///
    func updateUserProfileInFirebaseDatabase(uid: String, userDictionary: [String: Any], completion: @escaping (String, Bool) -> Void)
    
    /// Fetches user's profile from Firebase **Realtime Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the profile was successfully updated in **Firebase**, this argument contains a success message. Otherwise, it contains the reason why the profile updation failed.
    ///     2. `Bool`: Indicating whether the profile was updated or not.
    ///
    /// - Parameters:
    ///   - uid: An object of type `UserModel`.
    ///   - completion: An escaping closure with one argument.
    ///
    func fetchUserProfileFromFirebaseDatabase(uid: String, completion: @escaping ([String: Any]?) -> Void)
    
    /// Uploads user's post's metadata to **Firebase Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String?`: If the photo's `metadata` was successfully uploaded to **Firebase**, this argument contains the `primary key` of the created record. Otherwise, it contains `nil`.
    ///     2. `Bool`: Indicating whether the photo's `metadata` was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - postMetadata: The `metadata` of the photo to be posted.
    ///   - userInfo: Some relevant information about the user.
    ///   - completion: An escaping closure with two arguments.
    ///
    func uploadPostMetadataToFirebaseDatabase(uid: String, postMetadata: [String: Any], userInfo: [String: String], completion: @escaping (String?, Bool) -> Void)
    
    /// Updates user's post's metadata in **Firebase Database**.
    ///
    /// - The parameter `completion` has one argument:
    ///     - `Bool`: Indicating whether the photo's `metadata` was updated or not.
    ///
    /// - Parameters:
    ///   - uidUser: The unique identifier of a user stored in **Firebase**.
    ///   - primaryKeyPost: The `primary key` of the user's post.
    ///   - postMetadata: The `metadata` of the photo to be posted.
    ///   - completion: An escaping closure with one argument.
    ///
    func updatePostMetadataInFirebaseDatabase(uidUser: String, primaryKeyPost: String, postMetadata: [String: Any], completion: @escaping (Bool) -> Void)
    
    /// Fetches post metadata from **Firebase Database**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `Result`: If the fetch was successful, it contains an array of ``PostModel``. Otherwise, it contains error message.
    ///
    /// - Parameter completion: An escaping closure with one parameter.
    ///
    func fetchPostsMetadataFromFirebaseDatabase(completion: @escaping (Result<[PostModel], Error>) -> Void)
    
    /// Fetches post metadata from **Firebase Database** for the provided `uid`.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `Result`: If the fetch was successful, it contains an array of ``PostModel``. Otherwise, it contains error message.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in **Firebase**.
    ///   - completion: An escaping closure with one parameter.
    ///
    func fetchPostsMetadataFromFirebaseDatabaseFor(uid: String, completion: @escaping (Result<[PostModel], Error>) -> Void)
    
    /// Updates `userInfo` in **Firebase Database**.
    ///
    /// - Used to update `UserInfo` key's values in `posts` field present in **Firebase Database**.
    /// - If the `userInfo` field is not present in **Firebase Database**, this function creates it.
    /// - The parameter `completion` has one argument:
    ///     1. `Bool`: Indicating whether the `userInfo` was updated or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in **Firebase**.
    ///   - updateField: Enum case of type ``UpdateUserInfo``.
    ///   - completion: An escaping closure with one argument.
    ///
    func updateUserInfoInFirebaseDatabase(uid: String, updateField: UpdateUserInfo, completion: @escaping (Bool) -> Void)
}
