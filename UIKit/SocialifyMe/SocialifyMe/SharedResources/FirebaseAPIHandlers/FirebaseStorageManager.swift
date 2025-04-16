//
//  FirebaseStorageManager.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import FirebaseAuth
import FirebaseStorage

/// `Singleton` class for managing `API` calls to `Firebase Storage`.
///
/// - Properties:
///     - ``storageRef``
///
/// - Functions:
///     - ``uploadProfilePhotoToFirebaseStorage(uid:from:completion:)``
///     - ``downloadProfilePhotoFromFirebaseStorage(uid:completion:)``
///     - ``uploadPostToFirebaseStorage(user:from:description:completion:)``
///
class FirebaseStorageManager: FirebaseStorageManagerProtocol {
    var storageRef: StorageReference!
    
    static let shared = FirebaseStorageManager()
    
    private init() {
        self.storageRef = Storage.storage().reference()
    }
        
    //MARK: - Upload Profile Photo To Firebase Storage
    /// Uploads user's profile photo to **Firebase Storage**.
    ///
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains the reason why the upload failed.
    ///     2. `String`: If the upload was successful, this argument contains the download `URL` of the profile photo. Otherwise, it contains nil.
    ///     2. `Bool`: Indicating whether the profile photo was uploaded or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in Firebase.
    ///   - urlPath: Local storage URL of profile photo.
    ///   - completion: An escaping closure with two arguments.
    ///
    func uploadProfilePhotoToFirebaseStorage(uid: String, from urlPath: URL, completion: @escaping (String, String?, Bool) -> Void) {
        let profilePhotoRef = self.storageRef.child("data").child("users").child(uid).child(Constants.ProfilePhoto.name).child(Constants.ProfilePhoto.name + Constants.ProfilePhoto.extn)
        let profilePhotoMetadata = StorageMetadata()
        profilePhotoMetadata.contentType = "image/jpeg"
        
        let uploadTask = profilePhotoRef.putFile(from: urlPath, metadata: profilePhotoMetadata)
        
        uploadTask.observe(.success) { _ in
            uploadTask.removeAllObservers()
            
            profilePhotoRef.downloadURL { downloadURL, error in
                guard let downloadURL = downloadURL else {
                    completion(Constants.Alerts.Messages.successfulProfilePhotoUpload, nil, true)
                    return
                }
                FirebaseRealtimeDatabaseManager.shared.updateUserInfoInFirebaseDatabase(uid: uid, updateField: .userProfilePhotoFirebaseStorageURL(downloadURL.absoluteString)) { _ in }
                
                completion(Constants.Alerts.Messages.successfulProfilePhotoUpload, downloadURL.absoluteString, true)
            }
        }
        
        uploadTask.observe(.failure) { _ in
            uploadTask.removeAllObservers()
            completion(Constants.Alerts.Messages.unsuccessfulProfilePhotoUpload, nil, false)
        }
    }
    
    // MARK: - Download Profile Photo From Firebase Storage
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
    func downloadProfilePhotoFromFirebaseStorage(uid: String, completion: @escaping (URL?, Bool) -> Void) {
        let profilePhotoRef = self.storageRef.child("data").child("users").child(uid).child("profilePhoto").child("profilePhoto.jpeg")
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localProfilePhoto = documentDirectory.appending(path: "profilePhoto.jpeg")
        
        profilePhotoRef.write(toFile: localProfilePhoto) { url, error in
            if let error = error {
                print("COULD NOT DOWNLOAD PROFILE PHOTO: \(error)")
                completion(nil, false)
            }
            
            if let profilePhotoURL = url {
                if let imageData = try? Data(contentsOf: profilePhotoURL) {
                    try? imageData.write(to: localProfilePhoto)
                }
                
                completion(url, true)
            }
        }
    }
    
    //MARK: - Upload Post To Firebase Storage
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
    func uploadPostToFirebaseStorage(user: LocalUser, from urlPath: URL, postDescription: String?, completion: @escaping (String, Bool) -> Void) {
        let postMetadata = StorageMetadata()
        postMetadata.contentType = "image/jpeg"

        let postTimeCreated = HelperFunctions.shared.localDateTimeToGMT()
        
        var postMetadataDictionary: [String: Any] = ["contentType": "image/jpeg",
                                                     "postDescription": postDescription ?? "",
                                                     "postTimeCreated": postTimeCreated,
                                                     "usersWhoLikedThisPost": [String()],
                                                     "usersWhoBookmarkedThisPost": [String()]]
        
        let userInfo: [String: String] = ["userName": user.firstName! + " " + (user.lastName ?? ""),
                                          "userProfilePhotoFirebaseStorageURL": user.profilePhotoFirebaseStorageURL ?? ""]
        
        FirebaseRealtimeDatabaseManager.shared.uploadPostMetadataToFirebaseDatabase(uid: user.uid!, postMetadata: postMetadataDictionary, userInfo: userInfo) { [weak self] primaryKey, isPostMetadataUploaded in
            if let primaryKey = primaryKey,
               isPostMetadataUploaded {
                let postRef = self?.storageRef.child("data").child("posts").child(user.uid!).child(primaryKey)
                let uploadTask = postRef?.putFile(from: urlPath, metadata: postMetadata)
                
                uploadTask?.observe(.success) { _ in
                    uploadTask?.removeAllObservers()
                    
                    postRef?.downloadURL { downloadURL, downloadError in
                        if let downloadURL = downloadURL?.absoluteString {
                            postMetadataDictionary["postPhotoStorageURL"] = downloadURL
                            FirebaseRealtimeDatabaseManager.shared.updatePostMetadataInFirebaseDatabase(uidUser: user.uid!, primaryKeyPost: primaryKey, postMetadata: postMetadataDictionary) { isPostMetadataUpdated in
                                if(isPostMetadataUpdated) {
                                    completion(Constants.Alerts.Messages.successfulPostUpload, true)
                                } else {
                                    completion(Constants.Alerts.Messages.successfulPostUpload, true)
                                }
                            }
                        } else {
                            completion(Constants.Alerts.Messages.successfulPostUpload, true)
                        }
                    }
                }
                
                uploadTask?.observe(.failure) { _ in
                    uploadTask?.removeAllObservers()
                    completion(Constants.Alerts.Messages.unsuccessfulPostUpload, false)
                }
            } else {
                completion(Constants.Alerts.Messages.unsuccessfulPostUpload, false)
            }
        }
    }
}
