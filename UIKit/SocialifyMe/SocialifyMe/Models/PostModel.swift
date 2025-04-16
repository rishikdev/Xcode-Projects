//
//  PostModel.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 13/03/23.
//

import Foundation

struct PostModel: Codable {
    var userUID: String?
    var userProfilePhotoFirebaseStorageURL: String?
    var userName: String?
    var usersWhoLikedThisPost: [String] = []
    var usersWhoBookmarkedThisPost: [String] = []
    var postID: String?
    var postPhotoStorageURL: String?
    var postTimeCreated: String?
    var postDescription: String?
}
