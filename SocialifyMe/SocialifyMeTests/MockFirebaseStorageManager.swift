//
//  MockFirebaseStorageManager.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import Foundation
@testable import SocialifyMe

class MockFirebaseStorageManager: FirebaseStorageManagerProtocol {
    
    var shouldAPICallSucceed: Bool
    
    init(shouldAPICallSucceed: Bool = true) {
        self.shouldAPICallSucceed = shouldAPICallSucceed
    }
    
    func uploadProfilePhotoToFirebaseStorage(uid: String, from urlPath: URL, completion: @escaping (String, String?, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", "DownloadURL", true)
        } else {
            completion("Unsuccessful", nil, false)
        }
    }
    
    func downloadProfilePhotoFromFirebaseStorage(uid: String, completion: @escaping (URL?, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion(URL(string: "www.google.com"), true)
        } else {
            completion(nil, false)
        }
    }
    
    func uploadPostToFirebaseStorage(user: SocialifyMe.LocalUser, from urlPath: URL, postDescription: String?, completion: @escaping (String, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", true)
        } else {
            completion("Unsuccessful", false)
        }
    }
}
