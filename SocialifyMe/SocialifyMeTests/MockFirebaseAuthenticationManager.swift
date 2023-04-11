//
//  MockFirebaseAuthenticationManager.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import FirebaseAuth
import UIKit
@testable import SocialifyMe

class MockFirebaseAuthenticationManager: FirebaseAuthenticationManagerProtocol {
    
    var shouldAPICallSucceed: Bool
    
    init(shouldAPICallSucceed: Bool = true) {
        self.shouldAPICallSucceed = shouldAPICallSucceed
    }
    
    func createAccount(email: String, password: String, completion: @escaping (String, Bool, User?) -> Void) {
        if(email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).count < 6) {
            completion("Unsuccessful", false, nil)
        } else {
            completion("Successful", true, nil)
        }
    }
    
    func determineProvider(for email: String, completion: @escaping (String) -> Void) {
        if(email.trimmingCharacters(in: .whitespaces).isEmpty) {
            completion("")
        } else {
            completion("SomeProvider")
        }
    }
    
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool, SocialifyMe.UserModel?) -> Void) {
        if(email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).count < 6) {
            completion("Unsuccessful", false, nil)
        } else {
            completion("Successful", true, UserModel(uid: "SomeUID", email: "SomeEmail"))
        }
    }
    
    func signInWithGoogle(withPresenting viewController: UIViewController, completion: @escaping (String, Bool, SocialifyMe.UserModel?, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", true, UserModel(uid: "SomeUID", email: "SomeEmail"), false)
        } else {
            completion("Unsuccessful", false, nil, false)
        }
    }
    
    func signInWithFacebook(viewController: UIViewController, completion: @escaping (String, Bool, SocialifyMe.UserModel?, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", true, UserModel(uid: "SomeUID", email: "SomeEmail"), false)
        } else {
            completion("Unsuccessful", false, nil, false)
        }
    }
    
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", true)
        } else {
            completion("Unsuccessful", false)
        }
    }
}
