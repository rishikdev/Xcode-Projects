//
//  SignedInSettingsViewModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import Foundation

/// `ViewModel` class for ``SettingsTabViewController``.
///
/// - Handles functionalities related to signing out users.
///
/// - Properties:
///     - ``firebaseAuthenticationManager``
///     - ``firebaseRealtimeDatabaseManager``
///     - ``coreDataManager``
///     - ``posts``
///
/// - Functions:
///     - ``fetchPostsMetadataFromFirebaseDatabaseFor(uid:completion:)``
///     - ``signOut(provider:completion:)``
///     - ``deleteAllLocalUsers(entity:)``
///
class SettingsTabViewModel {
    var firebaseAuthenticationManager: FirebaseAuthenticationManagerProtocol
    var firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol
    var coreDataManager: CoreDataManagerProtocol
    var posts: [PostModel] = []
    
    init(firebaseAuthenticationManager: FirebaseAuthenticationManagerProtocol, firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.firebaseAuthenticationManager = firebaseAuthenticationManager
        self.firebaseRealtimeDatabaseManager = firebaseRealtimeDatabaseManager
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Fetch Posts From Firebase Database
    /// Fetches post metadata from **Firebase Database** for the provided `uid`.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the fetch was successful, it contains a succcess message. Otherwise, it contains error message.
    ///     2. `Bool`: Indicating whether the fetch was successful or not.
    ///
    /// - Parameters:
    ///   - uid: The unique identifier of a user stored in **Firebase**.
    ///   - completion: An escaping closure with two parameters.
    ///
    func fetchPostsMetadataFromFirebaseDatabaseFor(uid: String, completion: @escaping(String, Bool) -> Void) {
        firebaseRealtimeDatabaseManager.fetchPostsMetadataFromFirebaseDatabaseFor(uid: uid) { result in
            switch(result) {
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
                
            case .failure(let error):
                print(error)
                completion(Constants.Alerts.Messages.unsuccessfulPostFetch, false)
            }
        }
    }
    
    // MARK: - Sign Out
    /// Signs users out.
    ///
    /// - Calls ``FirebaseAuthenticationManager/signOut(provider:completion:)`` function.
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the user was successfully signed out, this argument contains a success message. Otherwise, it contains the reason why the sign out process failed.
    ///     2. `Bool`: Indicating whether the user was signed out or not.
    ///
    /// - Parameter completion: An escaping closure with two arguments
    ///
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void) {
        firebaseAuthenticationManager.signOut(provider: provider) { message, isSignedOut in completion(message, isSignedOut) }
    }
    
    // MARK: - Delete All Local Users
    /// Deletes every object of the `entity` provided.
    ///
    /// Calls ``CoreDataManager/deleteAllLocalUsers(entity:)`` function
    ///
    /// - Parameter entity: Name of the entity the objects of which need to be deleted
    ///
    func deleteAllLocalUsers(entity: String) {
        coreDataManager.deleteAllLocalUsers(entity: entity)
    }
}
