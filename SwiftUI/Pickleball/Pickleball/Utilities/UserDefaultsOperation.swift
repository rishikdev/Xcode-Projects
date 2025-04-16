//
//  UserDefaultsOperation.swift
//  Pickleball
//
//  Created by Rishik Dev on 23/12/2024.
//

import Foundation

struct UserDefaultsOperation {
    
    /// Sets the value of the given `UserDefault` key
    ///
    /// - Parameters:
    ///   - key: Key of the `UserDefault` object
    ///   - value: Value to be set for the given `key`
    ///
    static func setUserDefaults<T: Any>(key: Constants.UserDefaults, to value: T) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    /// Returns the value of the given `UserDefault` key, if the key exists
    ///
    /// - Parameter key: Key of the `UserDefault`
    ///
    /// - Returns: Optional `Any` value associated with the given `key`. Returns `nil` if the `key` does not exist.
    ///
    static func getUserDefaultsValue(of key: Constants.UserDefaults) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
    }
}
