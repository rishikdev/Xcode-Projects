//
//  CustomUser.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 28/02/23.
//

import Foundation

struct UserModel {
    var uid: String
    var providerName: String?
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var age: Int?
    var gender: String?
    var email: String
    var phoneNumber: String?
    var dateOfBirth: Date?
    var city: String?
    var state: String?
    var country: String?
    var profilePhotoFirebaseStorageURL: String?
        
    init(uid: String, providerName: String? = nil, firstName: String? = nil, middleName: String? = nil, lastName: String? = nil, age: Int? = nil, gender: String? = nil, email: String, phoneNumber: String? = nil, dateOfBirth: Date? = nil, city: String? = nil, state: String? = nil, country: String? = nil, profilePhotoFirebaseStorageURL: String? = nil) {
        self.uid = uid
        self.providerName = providerName
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.age = age
        self.gender = gender
        self.email = email
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.city = city
        self.state = state
        self.country = country
        self.profilePhotoFirebaseStorageURL = profilePhotoFirebaseStorageURL
    }
}
