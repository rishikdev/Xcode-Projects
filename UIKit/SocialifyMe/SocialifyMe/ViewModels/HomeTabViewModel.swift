//
//  SignedInHomeViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 10/03/23.
//

import Foundation

/// `ViewModel` class for ``HomeTabViewController``.
///
/// - Handles functionalities related to **uploading posts**.
///
/// - Properties:
///     - ``firebaseRealtimeDatabaseManager``
///     - ``posts``
///     - ``signedInUserUID``
///
/// - Functions:
///     - ``fetchPostsMetadataFromFirebaseRealtimeDatabase(completion:)``
///     - ``addLikedPostToUserInfoInFirebaseRealtimeDatabase(post:isPostLiked:completion:)``
///     - ``addBookmarkedPostToUserInfoInFirebaseRealtimeDatabase(post:isPostBookmarked:completion:)``
///
class HomeTabViewModel {
    var firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol
    var posts: [PostModel] = []
    var signedInUserUID: String
    
    init(firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol, signedInUserUID: String) {
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
        self.signedInUserUID = signedInUserUID
    }
    
    // MARK: - Fetch Posts Metadata From Firebase Database
    /// Fetches post metadata from **Firebase Database**.
    ///
    /// - Calls ``FirebaseRealtimeDatabaseManager/fetchPostsMetadataFromFirebaseDatabase(completion:)``.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the upload was successful, this argument contains a success message. Otherwise, it contains a failure message.
    ///     2. `Bool`: Indicating whether the fetch was successful or not.
    ///
    /// - Parameters:
    ///   - completion: An escaping closure with two arguments.
    ///
    func fetchPostsMetadataFromFirebaseRealtimeDatabase(completion: @escaping (String, Bool) -> Void) {
        firebaseRealtimeDatabaseManager.fetchPostsMetadataFromFirebaseDatabase { result in
            switch(result) {
            case .failure(_):
                completion(Constants.Alerts.Messages.unsuccessfulPostFetch, false)
                
            case .success(let posts):
                self.posts = posts
                self.posts.sort { p1, p2 in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss:sssz"
                    dateFormatter.timeZone = .gmt
                    let date1 = dateFormatter.date(from: p1.postTimeCreated!)
                    let date2 = dateFormatter.date(from: p2.postTimeCreated!)
                    
                    return (date1 ?? Date()) > (date2 ?? Date())
                }
                completion(Constants.Alerts.Messages.successfulPostFetch, true)
            }
        }
    }
    
    // MARK: - Add Liked Post To UserInfo In Firebase Realtime Database
    /// Stores the post `liked` by the users in their `userInfo` field in **Firebase Database**.
    ///
    /// - If the user likes a post, it gets stored in the `userInfo` field of the user.
    /// - If the user removes the like from a previously liked post, the post is removed from the user's `userInfo` field.
    ///
    /// - Parameters:
    ///   - post: The `object` of the `post` liked/unliked by the user.
    ///   - isPostLiked: Bool value indicating whether the user liked the post or unliked a previously liked post.
    ///   - completion: An escaping closure with two arguments.
    ///
    func addLikedPostToUserInfoInFirebaseRealtimeDatabase(reactedPostID: String, isPostLiked: Bool, completion: @escaping (String, Bool) -> Void) {
        var reactedPost: PostModel = self.posts.filter { $0.postID == reactedPostID }.first!
        self.posts = self.posts.filter { $0.postID != reactedPostID }
        
        if(isPostLiked) {
            reactedPost.usersWhoLikedThisPost.append((SharedUser.shared.localUser?.uid)!)
        } else {
            reactedPost.usersWhoLikedThisPost = reactedPost.usersWhoLikedThisPost.filter { $0 != (SharedUser.shared.localUser?.uid)! }
        }
        
        self.posts.append(reactedPost)
        
        firebaseRealtimeDatabaseManager.updateUserInfoInFirebaseDatabase(uid: signedInUserUID, updateField: .likedPostID(post: reactedPost, isPostLiked: isPostLiked)) { isUserInfoUpdated in
            if(isUserInfoUpdated) {
                completion(Constants.Alerts.Titles.successful, true)
            } else {
                completion(Constants.Alerts.Titles.unsuccessful, false)
            }
        }
    }
    
    // MARK: - Add Bookmarked Post To UserInfo In Firebase Realtime Database
    /// Stores the post `bookmarked` by the users in their `userInfo` field in **Firebase Database**.
    ///
    /// - If the user bookmarks a post, it gets stored in the `userInfo` field of the user.
    /// - If the user removes the bookmark from a previously bookmarked post, the post is removed from the user's `userInfo` field.
    ///
    /// - Parameters:
    ///   - post: The `object` of the `post` liked/unliked by the user.
    ///   - isPostBookmarked: Bool value indicating whether the user bookmarked the post or removed the bookmark a previously bookmarked post.
    ///   - completion: An escaping closure with two arguments.
    ///
    func addBookmarkedPostToUserInfoInFirebaseRealtimeDatabase(reactedPostID: String, isPostBookmarked: Bool, completion: @escaping (String, Bool) -> Void) {
        var reactedPost: PostModel = self.posts.filter { $0.postID == reactedPostID }.first!
        self.posts = self.posts.filter { $0.postID != reactedPostID }
        
        if(isPostBookmarked) {
            reactedPost.usersWhoBookmarkedThisPost.append((SharedUser.shared.localUser?.uid)!)
        } else {
            reactedPost.usersWhoBookmarkedThisPost = reactedPost.usersWhoBookmarkedThisPost.filter { $0 != (SharedUser.shared.localUser?.uid)! }
        }
        
        self.posts.append(reactedPost)
        
        firebaseRealtimeDatabaseManager.updateUserInfoInFirebaseDatabase(uid: signedInUserUID, updateField: .bookmarkedPostID(post: reactedPost, isPostBookmarked: isPostBookmarked)) { isUserInfoUpdated in
            if(isUserInfoUpdated) {
                completion(Constants.Alerts.Titles.successful, true)
            } else {
                completion(Constants.Alerts.Titles.unsuccessful, false)
            }
        }
    }
}
