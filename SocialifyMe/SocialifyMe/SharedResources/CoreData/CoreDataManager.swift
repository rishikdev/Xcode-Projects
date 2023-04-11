//
//  CoreDataManager.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 03/03/23.
//

import CoreData

/// `Singleton` class for managing `data persistence` using `Core Data`.
///
/// - Properties:
///     - ``persistentContainer``
///
/// - Functions:
///     - ``fetchLocalUsers()``
///     - ``createUserProfileInLocalStorage(userModel:profilePhotoURL:)``
///     - ``updateUserProfileInLocalStorage(localUser:updatedUserModel:profilePhotoURL:)``
///     - ``deleteAllLocalUsers(entity:)``
///     - ``saveContext(context:)``
///     - ``getContext()``
///
class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SocialifyMe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent container failure: \(error)")
            }
        })
        return container
    }()
    
    // MARK: - Fetch User Profiles From Local Storage
    /// Fetches an array of LocalUsers
    ///
    /// - Returns: An array of `LocalUser` objects.
    ///
    /// - Note: There will be only one object of `LocalUser` in storage at any given time.
    ///
    func fetchLocalUsers() -> [LocalUser] {
        let context = getContext()
        let fetchRequest: NSFetchRequest<LocalUser> = LocalUser.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("FETCHING LOCAL USER FAILED \(error)")
        }
    }
    
    // MARK: - Create User Profile In Local Storage
    /// Persists user's information to local storage.
    ///
    /// - Parameters:
    ///   - userModel: An object of type ``UserModel`` to be stored in local storage.
    ///   - profilePhotoURL: An optional `URL` pointing to the device's local storage where the user's profile photo is stored.
    ///
    /// - Note: `profilePhotoURL` will be nil if the user does not have a profile photo.
    ///
    func createUserProfileInLocalStorage(userModel: UserModel, profilePhotoLocalStorageURL: URL?) {
        let context = getContext()
        let localUser = LocalUser(context: context)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        localUser.uid = userModel.uid
        localUser.providerName = userModel.providerName
        localUser.profilePhotoLocalStorageURL = profilePhotoLocalStorageURL
        localUser.profilePhotoFirebaseStorageURL = userModel.profilePhotoFirebaseStorageURL
        localUser.firstName = userModel.firstName
        localUser.middleName = userModel.middleName
        localUser.lastName = userModel.lastName
        localUser.age = Int16(userModel.age ?? 0)
        localUser.gender = userModel.gender
        localUser.email = userModel.email
        localUser.phoneNumber = userModel.phoneNumber
        localUser.dateOfBirth = userModel.dateOfBirth
        localUser.city = userModel.city
        localUser.state = userModel.state
        localUser.country = userModel.country
        
        saveContext(context: context)
    }
    
    // MARK: - Update User Profile In Local Storage
    /// Updates and persists user's information to local storage.
    ///
    /// - Parameters:
    ///   - localUser: An object of type `LocalUser` which is to be updated.
    ///   - updatedUserModel: An object of type  ``UserModel``  with updated information.
    ///   - profilePhotoURL: An optional `URL` pointing to the device's local storage where the user's profile photo is stored.
    ///
    /// - Note: `profilePhotoURL` will be nil if the user does not have a profile photo.
    ///
    func updateUserProfileInLocalStorage(localUser: LocalUser, updatedUserModel: UserModel, profilePhotoURL: URL?) {
        let context = getContext()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        localUser.profilePhotoLocalStorageURL = profilePhotoURL
        localUser.profilePhotoFirebaseStorageURL = updatedUserModel.profilePhotoFirebaseStorageURL
        localUser.firstName = updatedUserModel.firstName
        localUser.middleName = updatedUserModel.middleName
        localUser.lastName = updatedUserModel.lastName
        localUser.age = Int16(updatedUserModel.age ?? 0)
        localUser.gender = updatedUserModel.gender
        localUser.phoneNumber = updatedUserModel.phoneNumber
        localUser.dateOfBirth = updatedUserModel.dateOfBirth
        localUser.city = updatedUserModel.city
        localUser.state = updatedUserModel.state
        localUser.country = updatedUserModel.country
        
        saveContext(context: context)
    }
    
    // MARK: - Delete All Local Users
    /// Deletes every object of the `entity` provided.
    ///
    /// Calls CoreDataManager's `deleteAllLocalUsers(entity)`
    ///
    /// - Parameter entity: Name of the entity the objects of which need to be deleted
    ///
    func deleteAllLocalUsers(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
    }
    
    // MARK: - Save Context
    /// Saves context
    /// - Parameter context: `context` of type `NSManagedObjectContext`
    func saveContext (context: NSManagedObjectContext) {
        if(context.hasChanges) {
            do {
                try context.save()
            } catch {
                fatalError("FAILED TO SAVE CONTEXT: \(error)")
            }
        }
    }
    
    // MARK: - Get Context
    /// Gets context
    /// - Returns: `ccontext` of type `NSManagedObjectContext`
    func getContext() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
