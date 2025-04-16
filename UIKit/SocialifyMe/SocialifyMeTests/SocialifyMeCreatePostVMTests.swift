//
//  SocialifyMeCreatePostVMTests.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import XCTest
@testable import SocialifyMe

final class SocialifyMeCreatePostVMTests: XCTestCase {
    
    var mockFirebaseStorageManager: MockFirebaseStorageManager!
    var createPostVM: CreatePostViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockFirebaseStorageManager = MockFirebaseStorageManager()
        createPostVM = CreatePostViewModel(firebaseStorageManager: mockFirebaseStorageManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        createPostVM = nil
    }
    
    // MARK: - Successful API Calls
    
    // MARK: Upload Post to Firebase Storage
    func testUploadPostToFirebaseStorageSuccessful() {
        mockFirebaseStorageManager.shouldAPICallSucceed = true
        let localUser = LocalUser()
        createPostVM.uploadPostToFirebaseStorage(user: localUser, from: URL(string: Constants.DefaultURLs.noPostPhoto)!, description: nil) { uploadPostMessage, isPostUploaded in
            XCTAssertTrue(isPostUploaded)
        }
    }
    
    // MARK: - Unsuccessful API Calls
    
    // MARK: Upload Post to Firebase Storage
    func testUploadPostToFirebaseStorageUnsuccessful() {
        mockFirebaseStorageManager.shouldAPICallSucceed = false
        let localUser = LocalUser()
        createPostVM.uploadPostToFirebaseStorage(user: localUser, from: URL(string: Constants.DefaultURLs.noPostPhoto)!, description: nil) { uploadPostMessage, isPostUploaded in
            XCTAssertFalse(isPostUploaded)
        }
    }
}
