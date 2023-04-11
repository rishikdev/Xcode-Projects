//
//  CoreDataManagerProtocol.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import CoreData

protocol CoreDataManagerProtocol {
//    var persistentContainer: NSPersistentContainer { get set }
    
    /// Fetches an array of LocalUsers
    ///
    /// - Returns: An array of `LocalUser` objects.
    ///
    /// - Note: There will be only one object of `LocalUser` in storage at any given time.
    ///
    func fetchLocalUsers() -> [LocalUser]
    
    /// Persists user's information to local storage.
    ///
    /// - Parameters:
    ///   - userModel: An object of type ``UserModel`` to be stored in local storage.
    ///   - profilePhotoURL: An optional `URL` pointing to the device's local storage where the user's profile photo is stored.
    ///
    /// - Note: `profilePhotoURL` will be nil if the user does not have a profile photo.
    ///
    func createUserProfileInLocalStorage(userModel: UserModel, profilePhotoLocalStorageURL: URL?)
    
    /// Updates and persists user's information to local storage.
    ///
    /// - Parameters:
    ///   - localUser: An object of type `LocalUser` which is to be updated.
    ///   - updatedUserModel: An object of type  ``UserModel``  with updated information.
    ///   - profilePhotoURL: An optional `URL` pointing to the device's local storage where the user's profile photo is stored.
    ///
    /// - Note: `profilePhotoURL` will be nil if the user does not have a profile photo.
    ///
    func updateUserProfileInLocalStorage(localUser: LocalUser, updatedUserModel: UserModel, profilePhotoURL: URL?)
    
    /// Deletes every object of the `entity` provided.
    ///
    /// Calls CoreDataManager's `deleteAllLocalUsers(entity)`
    ///
    /// - Parameter entity: Name of the entity the objects of which need to be deleted
    ///
    func deleteAllLocalUsers(entity: String)
}
