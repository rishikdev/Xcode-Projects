//
//  HelperFunctionsClass.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import Foundation

class HelperFunctions {
    static let shared = HelperFunctions()
    private init() {}
    
    private let dateFormatter = DateFormatter()
    
    func getUserDictionary(userModel: UserModel) -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        /// Not adding profilePhotoURL here as it is specific to a device. The URL obtained from the profile photo is of the image stored on device and not on firebase storage.
        
        var userDictionary = [String: Any]()
        userDictionary["providerName"] = userModel.providerName
        userDictionary["firstName"] = userModel.firstName
        userDictionary["middleName"] = userModel.middleName
        userDictionary["lastName"] = userModel.lastName
        userDictionary["age"] = userModel.age
        userDictionary["gender"] = userModel.gender
        userDictionary["email"] = userModel.email
        userDictionary["phoneNumber"] = userModel.phoneNumber
        userDictionary["dateOfBirth"] = dateFormatter.string(from: userModel.dateOfBirth ?? Date())
        userDictionary["city"] = userModel.city
        userDictionary["state"] = userModel.state
        userDictionary["country"] = userModel.country
        userDictionary["profilePhotoFirebaseStorageURL"] = userModel.profilePhotoFirebaseStorageURL
        
        return userDictionary
    }
    
    func localDateTimeToGMT() -> String {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss:sssz"
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = .gmt
        
        return dateFormatter.string(from: Date())
    }
    
    func GMTDateTimeToLocal(dateString: String) -> String? {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss:sssz"
        dateFormatter.locale = .autoupdatingCurrent
        dateFormatter.timeZone = .gmt
        
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm"
        dateFormatter.timeZone = .autoupdatingCurrent
        
        return dateFormatter.string(from: date ?? Date())
    }
    
    func postModelToPostDictionary(post: PostModel) -> [String: Any] {
        var postDictionary: [String: Any] = [:]
        
        postDictionary["contentType"] = "image/jpeg"
        postDictionary["postPhotoStorageURL"] = post.postPhotoStorageURL
        postDictionary["postTimeCreated"] = post.postTimeCreated
        postDictionary["postDescription"] = post.postDescription
        postDictionary["usersWhoLikedThisPost"] = post.usersWhoLikedThisPost
        postDictionary["usersWhoBookmarkedThisPost"] = post.usersWhoBookmarkedThisPost
        
        return postDictionary
    }
}
