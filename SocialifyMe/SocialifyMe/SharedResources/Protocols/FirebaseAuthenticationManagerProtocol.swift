//
//  ManagerProtocols.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 20/03/23.
//

import FirebaseAuth
import UIKit

protocol FirebaseAuthenticationManagerProtocol {
    /// Creates user's account on **Firebase**.
    ///
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the account creation was successful, this argument contains a success message. Otherwise, it contains the reason why the account creation failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `User?`: If the account creation was successful, this argument has an object of type User. Otherwise, it is nil.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - password: Password of the user.
    ///   - completion: An escaping closure with three arguments.
    ///
    func createAccount(email: String, password: String, completion: @escaping (String, Bool, User?) -> Void)
    
    /// Determines the **Provider** for a given **Email Address**.
    ///
    /// - The parameter `completion` has one argument:
    ///     1. `String`: If an account exists with the given email address, this argument contains the `provider` associated with that account. Otherwise, it contains an empty `String` signifying that no `provider` exists.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - completion: An escaping closure with one argument.
    ///
    /// - Note: An empty `provider` can signify two things: either the email is not registered on `Firebase`, or some `error` occurred while fetching `providers`.
    ///
    func determineProvider(for email: String, completion: @escaping (String) -> Void)
    
    /// Signs users in using their **Email Address** and **Password**.
    ///
    /// - The parameter `completion` has three arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `UserModel?`: If the authentication was successful, this argument has an object of type `UserModel`. Otherwise, it is nil.
    ///
    /// - Parameters:
    ///   - email: The email address of the user
    ///   - password: The password of the user
    ///   - completion: An escaping closure with three arguments
    ///
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool, UserModel?) -> Void)
    
    /// Signs users in using their **Google** credentials.
    ///
    /// - The parameter 'completion' has four arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `UserModel?`: If the authentication was successful, this argument has an object of type `UserModel`. Otherwise, it is nil.
    ///     4. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - viewController: The view controller calling this function
    ///   - completion: An escaping closure with four arguments
    ///
    func signInWithGoogle(withPresenting viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void)
    
    /// Signs users in using their **Facebook** credentials.
    ///
    ///  - The parameter 'completion' has four arguments:
    ///     1. `String`: If the authentication was successful, this argument contains a success message. Otherwise, it contains the reason why the authentication failed.
    ///     2. `Bool`: A Boolean value indicating whether the authentication was successful or not.
    ///     3. `UserModel?`: If the authentication was successful, this argument has an object of type `UserModel`. Otherwise, it is nil.
    ///     4. `Bool`: A Boolean value indicating whether the user is a new user or a returning user
    ///
    /// - Parameters:
    ///   - viewController: The view controller calling this function
    ///   - completion: An escaping closure with four arguments
    ///
    func signInWithFacebook(viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void)
    
    /// Signs users out.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the user was successfully signed out, this argument contains a success message. Otherwise, it contains the reason why the sign out process failed.
    ///     2. `Bool`: Indicating whether the user was signed out or not.
    ///
    /// - Parameter completion: An escaping closure with two arguments
    ///
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void)
}
