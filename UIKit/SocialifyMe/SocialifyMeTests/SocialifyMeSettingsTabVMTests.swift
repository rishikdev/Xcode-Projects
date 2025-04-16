//
//  SocialifyMeSettingsTabVMTests.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import XCTest
@testable import SocialifyMe

final class SocialifyMeSettingsTabVMTests: XCTestCase {
    var mockFirebaseAuthManager: MockFirebaseAuthenticationManager!
    var mockFirebaseRealtimeDatabaseManager: MockFirebaseRealtimeDatabaseManager!
    var mockCoreDataManager: MockCoreDataManager!
    var settingsTabVM: SettingsTabViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockFirebaseAuthManager = MockFirebaseAuthenticationManager()
        mockFirebaseRealtimeDatabaseManager = MockFirebaseRealtimeDatabaseManager()
        mockCoreDataManager = MockCoreDataManager()
        
        settingsTabVM = SettingsTabViewModel(firebaseAuthenticationManager: mockFirebaseAuthManager,
                                             firebaseRealtimeDatabaseManager: mockFirebaseRealtimeDatabaseManager,
                                             coreDataManager: mockCoreDataManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        settingsTabVM = nil
    }
    
    // MARK: - Successful API Calls
    
    // MARK: Fetch Posts Metadata from Firebase Database
    func testFetchPostsMetadataFromFirebaseDatabaseSuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = true
        settingsTabVM.fetchPostsMetadataFromFirebaseDatabaseFor(uid: "validUID") { fetchMessage, isFetchSuccessful in
            XCTAssertTrue(isFetchSuccessful)
        }
    }
    
    // MARK: Sign Out
    func testSignOutSuccessful() {
        mockFirebaseAuthManager.shouldAPICallSucceed = true
        settingsTabVM.signOut(provider: "validProvider") { signOutMessage, isSignOutSuccessful in
            XCTAssertTrue(isSignOutSuccessful)
        }
    }
    
    // MARK: Delete all Local Users
    func testDeleteAllLocalUsers() {
        mockCoreDataManager.createUserProfileInLocalStorage(userModel: UserModel(uid: "validUID", email: "validEmail"), profilePhotoLocalStorageURL: nil)
        var localUsers = mockCoreDataManager.fetchLocalUsers()
        XCTAssertEqual(localUsers.count, 1)
        
        settingsTabVM.deleteAllLocalUsers(entity: "validEntity")
        localUsers = mockCoreDataManager.fetchLocalUsers()
        XCTAssertEqual(localUsers.count, 0)
    }
    
    // MARK: - Unsuccessful API Calls
    
    // MARK: Fetch Posts Metadata from Firebase Database
    func testFetchPostsMetadatFromFirebaseDatabaseaUnsuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = false
        settingsTabVM.fetchPostsMetadataFromFirebaseDatabaseFor(uid: "validUID") { fetchMessage, isFetchSuccessful in
            XCTAssertFalse(isFetchSuccessful)
        }
    }
    
    // MARK: Sign Out
    func testSignOutUnsuccessful() {
        mockFirebaseAuthManager.shouldAPICallSucceed = false
        settingsTabVM.signOut(provider: "validProvider") { signOutMessage, isSignOutSuccessful in
            XCTAssertFalse(isSignOutSuccessful)
        }
    }
}
