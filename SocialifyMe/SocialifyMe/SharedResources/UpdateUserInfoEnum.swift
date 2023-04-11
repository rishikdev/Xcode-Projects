//
//  UpdateUserInfoEnum.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 21/03/23.
//

import Foundation

enum UpdateUserInfo {
    case userName(String)
    case userProfilePhotoFirebaseStorageURL(String)
    case likedPostID(post: PostModel, isPostLiked: Bool)
    case bookmarkedPostID(post: PostModel, isPostBookmarked: Bool)
}
