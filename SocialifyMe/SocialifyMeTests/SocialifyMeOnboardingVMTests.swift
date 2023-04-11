//
//  SocialifyMeTests.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import XCTest
@testable import SocialifyMe

final class SocialifyMeOnboardingVMTests: XCTestCase {

    var mockFirebaseAuthManager: MockFirebaseAuthenticationManager!
    var mockFirebaseRealtimeDatabaseManager: MockFirebaseRealtimeDatabaseManager!
    var onboardingVM: OnboardingViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockFirebaseAuthManager = MockFirebaseAuthenticationManager()
        mockFirebaseRealtimeDatabaseManager = MockFirebaseRealtimeDatabaseManager()
        
        onboardingVM = OnboardingViewModel(firebaseAuthenticationManager: mockFirebaseAuthManager,
                            firebaseStorageManager: MockFirebaseStorageManager(),
                            firebaseRealtimeDatabaseManager: mockFirebaseRealtimeDatabaseManager,
                            coreDataManager: MockCoreDataManager())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        onboardingVM = nil
    }
    
    // MARK: - Successful API Calls
    
    // MARK: Sign in with Email Password
    func testSignInWithEmailPasswordSuccessful() {
        onboardingVM.signInWithEmailPassword(email: "validEmail", password: "validPassword") { signInMessage, isSignInSuccessful in
            XCTAssertTrue(isSignInSuccessful)
        }
    }
    
    // MARK: Sign in with Google
    func testSignInWithGoogleSuccessful() {
        mockFirebaseAuthManager.shouldAPICallSucceed = true
        
        onboardingVM.signInWithGoogle(currentViewController: UIViewController()) { signInMessage, isSignInSuccessful, isNewUser in
            XCTAssertTrue(isSignInSuccessful)
        }
    }
    
    // MARK: Sign in with Facebook
    func testSignInWithFacebookSuccessful() {
        mockFirebaseAuthManager.shouldAPICallSucceed = true
        
        onboardingVM.signInWithFacebook(currentViewController: UIViewController()) { signInMessage, isSignInSuccessful, isNewUser in
            XCTAssertTrue(isSignInSuccessful)
        }
    }
    
    // MARK: Create profile in Firebase Database
    func testCreateProfileInFirebaseDatabaseSuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = true
        let userModel = UserModel(uid: "", email: "")
        
        onboardingVM.createUserProfileInFirebaseDatabase(userModel: userModel) { createProfileMessage, isProfileCreated in
            XCTAssertTrue(isProfileCreated)
        }
    }
    
    // MARK: - Unsuccessful API Calls
    
    // MARK: Sign in with wrong email
    func testSignInWithEmailPasswordUnsuccessfulWrongEmail() {
        onboardingVM.signInWithEmailPassword(email: "", password: "validPassword") { signInMessage, isSignInSuccessful in
            XCTAssertFalse(isSignInSuccessful)
        }
    }
    
    // MARK: Sign in with wrong password
    func testSignInWithEmailPasswordUnsuccessfulWronfPassword() {
        onboardingVM.signInWithEmailPassword(email: "validEmail", password: "") { signInMessage, isSignInSuccessful in
            XCTAssertFalse(isSignInSuccessful)
        }
    }
    
    // MARK: Sign in with wrong email and wrong password
    func testSignInWithEmailPasswordUnsuccessfulWrongEmailPassword() {
        onboardingVM.signInWithEmailPassword(email: "", password: "") { signInMessage, isSignInSuccessful in
            XCTAssertFalse(isSignInSuccessful)
        }
    }
    
    // MARK: Sign in with Google
    func testSignInWithGoogleUnsuccessful() {
        mockFirebaseAuthManager.shouldAPICallSucceed = false
        
        onboardingVM.signInWithGoogle(currentViewController: UIViewController()) { signInMessage, isSignInSuccessful, isNewUser in
            XCTAssertFalse(isSignInSuccessful)
        }
    }
    
    // MARK: Sign in with Facebook
    func testSignInWithFacebookUnsuccessful() {
        mockFirebaseAuthManager.shouldAPICallSucceed = false
        
        onboardingVM.signInWithFacebook(currentViewController: UIViewController()) { signInMessage, isSignInSuccessful, isNewUser in
            XCTAssertFalse(isSignInSuccessful)
        }
    }
    
    // MARK: Create profile in Firebase Database
    func testCreateProfileInFirebaseDatabaseUnsuccessful() {
        mockFirebaseRealtimeDatabaseManager.shouldAPICallSucceed = false
        let userModel = UserModel(uid: "", email: "")
        
        onboardingVM.createUserProfileInFirebaseDatabase(userModel: userModel) { createProfileMessage, isProfileCreated in
            XCTAssertFalse(isProfileCreated)
        }
    }
}
