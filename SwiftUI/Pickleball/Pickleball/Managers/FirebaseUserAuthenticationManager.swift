//
//  FirebaseUserAuthentication.swift
//  Pickleball
//
//  Created by Rishik Dev on 06/11/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

/// `Singleton` actor for managing `API` calls to `Firebase Authentication`.
///
/// - Functions:
///     - ``signUp(withEmail:password:)``
///     - ``signInWithApple(credential:)``
///     - ``signInWithGoogle(user:)``
///     - ``signInWithEmailPassword(email:password:)``
///     - ``logout()``
///     - ``deleteAccount(user:)``
///
actor FirebaseUserAuthenticationManager {
    private init() { }
    
    static let shared = FirebaseUserAuthenticationManager()
    
    /// Creates user's account on **Firebase**.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - password: Password of the user.
    ///
    /// Possible Error Codes:
    /// - `invalidEmail` - Indicates the email address is badly formatted.
    /// - `weakPassword` - Indicates the password is too weak.
    /// - `userAlreadyExists` - Indicates an account already exists with the provided email.
    /// - `networkError` - Indicates a network error occurred.
    /// - `unknownError` - Indicates some other error occurred.
    ///
    func signUp(withEmail email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch let signUpError as NSError {
            throw ErrorMapping.mapFirebaseError(signUpError)
        }
    }
    
    /// Signs in user to **Firebase** with the given 3rd-party credentials (e.g. a Facebook login Access Token, a Google ID Token/Access Token pair, etc.)
    /// and returns additional identity provider data.
    ///
    /// - Parameter credential: The credential supplied by the **IdP**
    ///
    /// - Returns: The `AuthDataResult` after the successful sign in.
    ///
    func signInWithApple(credential: OAuthCredential) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().signIn(with: credential)
            return result
        } catch {
            throw error
        }
    }
    
    /// Signs in user to **Firebase** using their **Google** account.
    ///
    /// - Parameter user: The GIDGoogleUser instance for the user who just completed the flow.
    ///
    func signInWithGoogle(user: GIDGoogleUser) async throws {
        do {
            guard let idToken = user.idToken else {
                throw FirebaseAuthError.unknownError("ID token missing")
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            try await Auth.auth().signIn(with: credential)
        } catch {
            throw error
        }
    }
    
    /// Signs in user to **Firebase** using their **email** and **password**.
    ///
    /// - Parameters:
    ///   - email: Email address of the user.
    ///   - password: Password of the user.
    ///
    /// Possible Error Codes:
    /// - `invalidEmail` - Indicates the email address is badly formatted.
    /// - `userDisabled` - Indicates the user account is disabled.
    /// - `networkError` - Indicates a network error occurred.
    /// - `invalidCredential` - Indicates either the email or the password is wrong.
    /// - `unknownError` - Indicates some other error occurred.
    ///
    func signInWithEmailPassword(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let error as NSError {
            throw ErrorMapping.mapFirebaseError(error)
        }
    }
    
    /// Signs out user
    nonisolated func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let logoutError as NSError {
            throw ErrorMapping.mapFirebaseError(logoutError)
        }
    }
    
    /// Deletes user's account from **Firebase**
    ///
    /// - Parameter user: Object of type `User` whose account needs to be deleted
    ///
    func deleteAccount(user: User) async throws {
        do {
            try await user.delete()
        } catch let deleteError as NSError {
            throw ErrorMapping.mapFirebaseError(deleteError)
        }
    }
}
