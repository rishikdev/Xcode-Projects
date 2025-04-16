//
//  MockCoreDataManager.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import Foundation
import CoreData
@testable import SocialifyMe

class MockCoreDataManager: CoreDataManagerProtocol {
    
    var shouldCallSucceed: Bool
    var localUsers: [LocalUser] = []
    
    init(shouldCallSucceed: Bool = true) {
        self.shouldCallSucceed = shouldCallSucceed
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SocialifyMe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent container failure: \(error)")
            }
        })
        return container
    }()
    
    func fetchLocalUsers() -> [SocialifyMe.LocalUser] {
        localUsers
    }
    
    func createUserProfileInLocalStorage(userModel: SocialifyMe.UserModel, profilePhotoLocalStorageURL: URL?) {
        localUsers = []
        let localUser = LocalUser(context: persistentContainer.viewContext)
        localUser.uid = userModel.uid
        localUser.firstName = userModel.firstName
        localUser.email = userModel.email
        localUsers.append(localUser)
    }
    
    func updateUserProfileInLocalStorage(localUser: SocialifyMe.LocalUser, updatedUserModel: SocialifyMe.UserModel, profilePhotoURL: URL?) {
        localUsers = []
        localUser.firstName = updatedUserModel.firstName
        localUsers.append(localUser)
    }
    
    func deleteAllLocalUsers(entity: String) {
        localUsers.removeAll()
    }
}
