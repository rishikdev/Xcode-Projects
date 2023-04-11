//
//  SocialifyMeHomeTabVMTests.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import XCTest
@testable import SocialifyMe

final class SocialifyMeHomeTabVMTests: XCTestCase {

    var mockFirebaseRealtimeDatabaseManager: MockFirebaseRealtimeDatabaseManager!
    var homeTabVM: HomeTabViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockFirebaseRealtimeDatabaseManager = MockFirebaseRealtimeDatabaseManager()
        homeTabVM = HomeTabViewModel(firebaseRealtimeDatabaseManager: mockFirebaseRealtimeDatabaseManager, signedInUserUID: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeTabVM = nil
    }
    
    // MARK: - Successful API Calls
    
    // MARK: Fetch Posts Metadata from Firebase Database
    func testFetchPostsMetadataFromFirebaseDatabaseSuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = true
        homeTabVM.fetchPostsMetadataFromFirebaseRealtimeDatabase { fetchMessage, isFetchSuccessful in
            XCTAssertTrue(isFetchSuccessful)
        }
    }
    
    // MARK: - Unsuccessful API Calls
    
    // MARK: Fetch Posts Metadata from Firebase Database
    func testFetchPostsMetadatFromFirebaseDatabaseaUnsuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = false
        homeTabVM.fetchPostsMetadataFromFirebaseRealtimeDatabase { fetchMessage, isFetchSuccessful in
            XCTAssertFalse(isFetchSuccessful)
        }
    }
}
