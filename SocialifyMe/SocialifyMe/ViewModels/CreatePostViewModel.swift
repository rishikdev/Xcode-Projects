//
//  CreatePostViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 14/03/23.
//

import Foundation

/// `View Model` class for ``CreatePostViewController``
///
/// - Handles functionalities related to **uploading posts**.
/// - Properties:
///     - ``firebaseStorageManager``
///     
/// - Functions:
///     - ``uploadPostToFirebaseStorage(user:from:description:completion:)``
///
class CreatePostViewModel {
    
    var firebaseStorageManager: FirebaseStorageManagerProtocol
    
    init(firebaseStorageManager: FirebaseStorageManagerProtocol) {
        self.firebaseStorageManager = firebaseStorageManager
    }
    
    // MARK: - Upload Post To Firebase Storage
    /// Uploads user's posts to **Firebase Storage**.
    ///
    /// - Calls ``FirebaseStorageManager/uploadPostToFirebaseStorage(user:from:postDescription:completion:)`` function.
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
    func uploadPostToFirebaseStorage(user: LocalUser, from urlPath: URL, description: String?, completion: @escaping (String, Bool) -> Void) {
        firebaseStorageManager.uploadPostToFirebaseStorage(user: user, from: urlPath, postDescription: description) { postUploadMessage, isPostUploaded in completion(postUploadMessage, isPostUploaded) }
    }
}
