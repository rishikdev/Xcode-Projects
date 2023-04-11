//
//  SocialifyMeEditProfileVMTests.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import XCTest
@testable import SocialifyMe

final class SocialifyMeEditProfileVMTests: XCTestCase {
    
    var mockFirebaseAuthManager: MockFirebaseAuthenticationManager!
    var mockFirebaseStorageManager: MockFirebaseStorageManager!
    var mockFirebaseRealtimeDatabaseManager: MockFirebaseRealtimeDatabaseManager!
    var mockCoreDataManager: MockCoreDataManager!
    var editProfileVM: EditProfileViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockFirebaseAuthManager = MockFirebaseAuthenticationManager()
        mockFirebaseStorageManager = MockFirebaseStorageManager()
        mockFirebaseRealtimeDatabaseManager = MockFirebaseRealtimeDatabaseManager()
        mockCoreDataManager = MockCoreDataManager()
        
        editProfileVM = EditProfileViewModel(firebaseAuthenticationManager: mockFirebaseAuthManager,
                                             firebaseStorageManager: mockFirebaseStorageManager,
                                             firebaseRealtimeDatabaseManager: mockFirebaseRealtimeDatabaseManager,
                                             coreDataManager: mockCoreDataManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        editProfileVM = nil
    }
    
    // MARK: - Successful API Calls
    
    // MARK: Create User Profile in Firebase Database
    func testCreateUserProfileInFirebaseDatabaseSuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = true
        let userModel = UserModel(uid: "", email: "")
        
        editProfileVM.createUserProfileInFirebaseDatabase(userModel: userModel) { createProfileMessage, isProfileCreated in
            XCTAssertTrue(isProfileCreated)
        }
    }
    
    // MARK: Update User Profile in Firebase Database
    func testUpdateUserProfileInFirebaseDatabaseSuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = true
        let userModel = UserModel(uid: "", email: "")
        
        editProfileVM.updateUserProfileInFirebaseDatabase(userModel: userModel) { updateProfileMessage, isProfileUpdated, updatedUserModel in
            XCTAssertTrue(isProfileUpdated)
        }
    }
    
    // MARK: Upload Profile Photo to Firebase Storage
    func testUploadProfilePhotoToFirebaseStorageSuccessful() {
        mockFirebaseStorageManager.shouldAPICallSucceed = true
        
        editProfileVM.uploadProfilePhotoToFirebaseStorage(uid: "validUID", from: URL(string: Constants.DefaultURLs.noProfilePhoto)!) { uploadProfilePhotoMessage, downloadURL, isProfilePhotoUploaded in
            XCTAssertTrue(isProfilePhotoUploaded)
        }
    }
    
    // MARK: Download Profile Photo From Firebase Storage
    func testDownloadProfilePhotoFromFirebaseStorageSuccessful() {
        mockFirebaseStorageManager.shouldAPICallSucceed = true
        
        editProfileVM.downloadProfilePhotoFromFirebaseStorage(uid: "validUID") { localStorageURL, isProfilePhotoDownloaded in
            XCTAssertTrue(isProfilePhotoDownloaded)
        }
    }
    
    // MARK: Create Account
    func testCreateAccountSuccessful() {
        editProfileVM.createAccount(email: "validEmail", password: "validPassword") { createAccountMessage, isAccountCreated, user in
            XCTAssertTrue(isAccountCreated)
        }
    }
    
    // MARK: Create User Profile in Local Storage
    func testCreateUserProfileInLocalStorageSuccessful() {
        mockCoreDataManager.createUserProfileInLocalStorage(userModel: UserModel(uid: "validUID", email: "validEmail"), profilePhotoLocalStorageURL: nil)
        
        var localUsers = editProfileVM.fetchUserProfilesFromLocalStorage()
        XCTAssertEqual(localUsers.count, 1)
        
        mockCoreDataManager.deleteAllLocalUsers(entity: "validEntity")
        localUsers = editProfileVM.fetchUserProfilesFromLocalStorage()
        XCTAssertEqual(localUsers.count, 0)
    }
    
    // MARK: Update User Profile in Local Storage
    func testUpdateUserProfileInLocalStorageSuccessful() {
        mockCoreDataManager.createUserProfileInLocalStorage(userModel: UserModel(uid: "validUID", firstName: "newFirstName", email: "validEmail"), profilePhotoLocalStorageURL: nil)
        
        var localUsers = editProfileVM.fetchUserProfilesFromLocalStorage()
        XCTAssertEqual(localUsers[0].firstName, "newFirstName")
        
        editProfileVM.updateUserProfileInLocalStorage(localUser: localUsers[0], updatedUserModel: UserModel(uid: "validUID", firstName: "updatedFirstName", email: "validEmail"), profilePhotoURL: nil)
        
        localUsers = editProfileVM.fetchUserProfilesFromLocalStorage()
        XCTAssertEqual(localUsers[0].firstName, "updatedFirstName")
        
        mockCoreDataManager.deleteAllLocalUsers(entity: "validEntity")
        localUsers = editProfileVM.fetchUserProfilesFromLocalStorage()
        XCTAssertEqual(localUsers.count, 0)
    }
    
    // MARK: - Unsuccessful API Calls
    
    // MARK: Create User Profile in Firebase Database
    func testCreateUserProfileInFirebaseDatabaseUnsuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = false
        let userModel = UserModel(uid: "", email: "")
        
        editProfileVM.createUserProfileInFirebaseDatabase(userModel: userModel) { createProfileMessage, isProfileCreated in
            XCTAssertFalse(isProfileCreated)
        }
    }
    
    // MARK: Update User Profile in Firebase Database
    func testUpdateUserProfileInFirebaseDatabaseUnsuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = false
        let userModel = UserModel(uid: "", email: "")
        
        editProfileVM.updateUserProfileInFirebaseDatabase(userModel: userModel) { updateProfileMessage, isProfileUpdated, updatedUserModel in
            XCTAssertFalse(isProfileUpdated)
        }
    }
    
    // MARK: Upload Profile Photo to Firebase Storage
    func testUploadProfilePhotoToFirebaseStorageUnsuccessful() {
        mockFirebaseStorageManager.shouldAPICallSucceed = false
        
        editProfileVM.uploadProfilePhotoToFirebaseStorage(uid: "validUID", from: URL(string: Constants.DefaultURLs.noProfilePhoto)!) { uploadProfilePhotoMessage, downloadURL, isProfilePhotoUploaded in
            XCTAssertFalse(isProfilePhotoUploaded)
        }
    }
    
    // MARK: Download Profile Photo From Firebase Storage
    func testDownloadProfilePhotoFromFirebaseStorageUnsuccessful() {
        mockFirebaseStorageManager.shouldAPICallSucceed = false
        
        editProfileVM.downloadProfilePhotoFromFirebaseStorage(uid: "validUID") { localStorageURL, isProfilePhotoDownloaded in
            XCTAssertFalse(isProfilePhotoDownloaded)
        }
    }
    
    // MARK: Create Account wrong email
    func testCreateAccountUnsuccessfulWrongEmail() {
        editProfileVM.createAccount(email: "", password: "ValidPassword") { createAccountMessage, isAccountCreated, user in
            XCTAssertFalse(isAccountCreated)
        }
    }
    
    // MARK: Create Account wrong password
    func testCreateAccountUnsuccessfulWrongPassword() {
        editProfileVM.createAccount(email: "validEmail", password: "") { createAccountMessage, isAccountCreated, user in
            XCTAssertFalse(isAccountCreated)
        }
    }
    
    // MARK: Create Account wrong email and wrong password
    func testCreateAccountUnsuccessful() {
        editProfileVM.createAccount(email: "", password: "") { createAccountMessage, isAccountCreated, user in
            XCTAssertFalse(isAccountCreated)
        }
    }
}
