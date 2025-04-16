//
//  SharedUser.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 10/03/23.
//

import Foundation

class SharedUser {
    static let shared = SharedUser()
    var localUser: LocalUser?
    
    private init(localUser: LocalUser? = nil) {
        self.localUser = localUser
    }
}
