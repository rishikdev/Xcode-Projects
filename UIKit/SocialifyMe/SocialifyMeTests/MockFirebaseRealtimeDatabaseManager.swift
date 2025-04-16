//
//  MockFirebaseRealtimeDatabaseManager.swift
//  SocialifyMeTests
//
//  Created by Rishik Dev on 20/03/23.
//

import Foundation
@testable import SocialifyMe

class MockFirebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManagerProtocol {
    var shouldAPICallSucceed: Bool
    
    init(shouldAPICallSucceed: Bool = false) {
        self.shouldAPICallSucceed = shouldAPICallSucceed
    }
    
    func createUserProfileInFirebaseDatabase(uid: String, userDictionary: [String : Any], completion: @escaping (String, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", true)
        } else {
            completion("Unsuccessful", false)
        }
    }
    
    func updateUserProfileInFirebaseDatabase(uid: String, userDictionary: [String : Any], completion: @escaping (String, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("Successful", true)
        } else {
            completion("Unsuccessful", false)
        }
    }
    
    func fetchUserProfileFromFirebaseDatabase(uid: String, completion: @escaping ([String : Any]?) -> Void) {
        if(shouldAPICallSucceed) {
            completion(["fetched": true])
        } else {
            completion(["fetched": false])
        }
    }
    
    func uploadPostMetadataToFirebaseDatabase(uid: String, postMetadata: [String : Any], userInfo: [String : String], completion: @escaping (String?, Bool) -> Void) {
        if(shouldAPICallSucceed) {
            completion("PostPhotoURL", true)
        } else {
            completion(nil, false)
        }
    }
    
    func fetchPostsMetadataFromFirebaseDatabase(completion: @escaping (Result<[SocialifyMe.PostModel], Error>) -> Void) {
        if(shouldAPICallSucceed) {
            var post = PostModel()
            post.userName = "Successful"
            completion(.success([post]))
        } else {
            completion(.failure(CustomError.fetchError))
        }
    }
    
    func fetchPostsMetadataFromFirebaseDatabaseFor(uid: String, completion: @escaping (Result<[SocialifyMe.PostModel], Error>) -> Void) {
        if(shouldAPICallSucceed) {
            var post = PostModel()
            post.userName = "Successful"
            completion(.success([post]))
        } else {
            completion(.failure(CustomError.fetchError))
        }
    }
    
    func updateUserInfoInFirebaseDatabase(uid: String, userName: String?, profilePhotoFirebaseStorageURL: String?) {
        if(shouldAPICallSucceed) {
            print("Updation Successful")
        } else {
            print("Updation Unsuccessful")
        }
    }
    
    func updateUserInfoInFirebaseDatabase(uid: String, updateField: SocialifyMe.UpdateUserInfo) {
        
    }
}

enum CustomError: Error {
    case fetchError
}
