//
//  FirebaseStorageManagerProtocol.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import Foundation

/// Protocol for `FirebaseStorageManager` class.
///
/// Functions:
///  - ``uploadProfilePhotoToFirebaseStorage(uid:urlPath:completion:)``
///  - ``downloadProfilePhotoFromFirebaseStorage(uid:completion:)``
///  - ``uploadPostToFirebaseStorage(user:urlPath:postDescription:completion:)``
///
protocol FirebaseStorageManagerProtocol {
    /// Uploads user's profile photo to **Firebase Storage**.
    ///
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains the reason why the upload failed.
    ///     2. `String`: If the upload was successful, this argument contains the download `URL` of the profile photo. Otherwise, it contains nil.
    ///     3. `Bool`: Indicating whether the profile photo was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - urlPath: Local storage URL of profile photo.
    ///   - completion: An escaping closure with three arguments.
    ///
    func uploadProfilePhotoToFirebaseStorage(uid: String, from urlPath: URL, completion: @escaping (String, String?, Bool) -> Void)
    
    /// Downloads user's profile photo from **Firebase Storage** to **local storage**.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `URL?`: If the profile photo was downloaded successfully, this argument contains the path of the downloaded profile photo. Otherwise, it is nil.
    ///     2. `Bool`: Indicating whether the profile photo was downloaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - completion: An escaping closure with two arguments.
    ///
    func downloadProfilePhotoFromFirebaseStorage(uid: String, completion: @escaping (URL?, Bool) -> Void)
    
    /// Uploads user's posts to **Firebase Storage**.
    ///
    /// - Calls ``FirebaseRealtimeDatabaseManager/uploadPostMetadataToFirebaseDatabase(uid:postMetadata:userInfo:completion:)`` to upload the `metadata` of the selected photo to **Firebase Realtime Database** to get the `primary key` associated with it.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains the reason why the upload failed.
    ///     2. `Bool`: Indicating whether the photo was uploaded or not.
    ///
    /// - Parameters:
    ///   - user: An object of `LocalUser`.
    ///   - urlPath: Local storage URL of photo to be posted.
    ///   - description: A description of the post.
    ///   - completion: An escaping closure with two arguments.
    ///
    func uploadPostToFirebaseStorage(user: LocalUser, from urlPath: URL, postDescription: String?, completion: @escaping (String, Bool) -> Void)
}
