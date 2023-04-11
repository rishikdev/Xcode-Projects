//
//  FirebaseManager.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

/// `Singleton` class for managing `API` calls to `Firebase Authentication`.
///
/// - Properties:
///     - ``facebookLoginManager``
///
/// - Functions:
///     - ``createAccount(email:password:completion:)``
///     - ``determineProvider(for:completion:)``
///     - ``signInWithEmailPassword(email:password:completion:)``
///     - ``signInWithGoogle(withPresenting:completion:)``
///     - ``signInWithFacebook(viewController:completion:)``
///     - ``signOut(completion:)``
///
class FirebaseAuthenticationManager: FirebaseAuthenticationManagerProtocol {
    var facebookLoginManager: LoginManager!
    
    static let shared = FirebaseAuthenticationManager()
    
    private init() {
        self.facebookLoginManager = LoginManager()
    }
        
    // MARK: - Create Account
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
    func createAccount(email: String, password: String, completion: @escaping (String, Bool, User?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error as? AuthErrorCode {
                print("ERROR CREATING ACCOUNT: \(error.errorCode)\n \(error)")
                
                self?.determineProvider(for: email) { provider in
                    if(provider == Constants.Providers.noProvider) {
                        /// This indicates that the email address is not in use. Something else is wrong.
                        switch(error.code) {
                        case .invalidEmail:
                            print("EMAIL")
                        case .weakPassword:
                            print("PASSWORD")
                        default:
                            print(error)
                        }
                        completion(error.localizedDescription, false, nil)
                    } else {
                        /// This indicates that the email is already in use by another provider.
                        ///
                        /// The user previously signed up with email address and password.
                        if(provider == Constants.Providers.emailPassword) {
                            completion(Constants.Alerts.Messages.unsuccessfulSignUpUserAlreadyExists, false, nil)
                        } else {
                            /// The user previously signed up with a different provider.
                            completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil)
                        }
                    }
                }
            }
            
            if let user = authResult?.user {
                completion(Constants.Alerts.Messages.successfulSignUp, true, user)
            }
        }
    }
    
    // MARK: - Determine Provider
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
    func determineProvider(for email: String, completion: @escaping (String) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { result, error in
            if let result = result {
                completion(result[0])
                return
            } else {
                completion(Constants.Providers.noProvider)
            }
            
            if let error = error {
                print("ERROR FETCHING PROVIDER: \(error)")
                completion(Constants.Providers.noProvider)
                return
            }
        }
    }
    
    // MARK: - Sign In With Email Password
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
    func signInWithEmailPassword(email: String, password: String, completion: @escaping (String, Bool, UserModel?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
                            
            if let error = error as? AuthErrorCode {
                print("ERROR SIGNING In: \(error.errorCode)\n \(error)")
                
                strongSelf.determineProvider(for: email) { provider in
                    if(provider == Constants.Providers.noProvider || provider == Constants.Providers.emailPassword) {
                        /// This indicates that the email address is not in use. Something else is wrong.
                        completion(Constants.Alerts.Messages.unsuccessfulSignIn, false, nil)
                    } else {
                        /// This indicates that the email is already in use by another provider.
                        completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil)
                    }
                }
            }
            
            if let user = authResult?.user {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                FirebaseRealtimeDatabaseManager.shared.fetchUserProfileFromFirebaseDatabase(uid: user.uid) { userProfile in
                    let userModel = UserModel(uid: user.uid,
                                              providerName: userProfile?["providerName"] as? String,
                                              firstName: userProfile?["firstName"] as? String,
                                              middleName: userProfile?["middleName"] as? String,
                                              lastName: userProfile?["lastName"] as? String,
                                              age: userProfile?["age"] as? Int,
                                              gender: userProfile?["gender"] as? String,
                                              email: userProfile?["email"] as! String,
                                              phoneNumber: userProfile?["phoneNumber"] as? String,
                                              dateOfBirth: dateFormatter.date(from: userProfile?["dateOfBirth"] as! String),
                                              city: userProfile?["city"] as? String,
                                              state: userProfile?["state"] as? String,
                                              country: userProfile?["country"] as? String,
                                              profilePhotoFirebaseStorageURL: userProfile?["profilePhotoFirebaseStorageURL"] as? String)

                    completion(Constants.Alerts.Messages.successfulSignIn, true, userModel)
                }
            }
        }
    }
    
    // MARK: - Sign In With Google
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
    func signInWithGoogle(withPresenting viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] result, error in
            
            if let error = error {
                print("ERROR SIGNING IN WITH GOOGLE: \(error)")
                /// This occurs when the user presses 'Cancel' when presented with '... wants to use google.com to sign in'.
                completion(Constants.Errors.operationTerminatedByTheUser, false, nil, false)
                return
            }

            guard let googleUser = result?.user,
                  let idToken = googleUser.idToken?.tokenString,
                  let email = googleUser.profile?.email else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: googleUser.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                                
                if let error = error as? AuthErrorCode {
                    self.determineProvider(for: email) { [weak self] provider in
                        print("AUTH ERROR: \(error.errorCode)\n \(error)")
                        
                        self?.determineProvider(for: email) { provider in
                            if(provider == Constants.Providers.noProvider) {
                                /// This indicates that the email address is not in use. Something else is wrong.
                                completion(error.localizedDescription, false, nil, false)
                            } else if(provider == Constants.Providers.emailPassword) {
                                /// The user previously signed up with email address and password.
                                completion(Constants.Alerts.Messages.unsuccessfulSignUpUserAlreadyExists, false, nil, false)
                            } else if(provider != Constants.Providers.google) {
                                /// The user previously signed up with a different provider
                                completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil, false)
                            }
                        }
                    }
                }
                
                if let authResult = authResult,
                   let isNewUser = authResult.additionalUserInfo?.isNewUser {
                    let user = authResult.user
                    
                    if(isNewUser) {
                        /// If the user has signed in with Google for the first time, fetch user's data from Google
                        let userModel = UserModel(uid: authResult.user.uid,
                                                  providerName: Constants.Providers.google,
                                                  firstName: googleUser.profile?.givenName,
                                                  middleName: "",
                                                  lastName: googleUser.profile?.familyName,
                                                  email: email)
                        completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                    } else {
                        /// If this is a returning user, then fetch user's data from Firebase Realtime Database
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .short
                        
                        FirebaseRealtimeDatabaseManager.shared.fetchUserProfileFromFirebaseDatabase(uid: user.uid) { userProfile in
                            let userModel = UserModel(uid: user.uid,
                                                      providerName: userProfile?["providerName"] as? String,
                                                      firstName: userProfile?["firstName"] as? String,
                                                      middleName: userProfile?["middleName"] as? String,
                                                      lastName: userProfile?["lastName"] as? String,
                                                      age: userProfile?["age"] as? Int,
                                                      gender: userProfile?["gender"] as? String,
                                                      email: userProfile?["email"] as! String,
                                                      phoneNumber: userProfile?["phoneNumber"] as? String,
                                                      dateOfBirth: dateFormatter.date(from: userProfile?["dateOfBirth"] as! String),
                                                      city: userProfile?["city"] as? String,
                                                      state: userProfile?["state"] as? String,
                                                      country: userProfile?["country"] as? String,
                                                      profilePhotoFirebaseStorageURL: userProfile?["profilePhotoFirebaseStorageURL"] as? String)
                            completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sign In With Facebook
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
    func signInWithFacebook(viewController: UIViewController, completion: @escaping (String, Bool, UserModel?, Bool) -> Void) {
        facebookLoginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { result, error in
            guard let accessToken = AccessToken.current else {
                completion(Constants.Errors.operationTerminatedByTheUser, false, nil, false)
                return
            }
            
            /// This condition is true when the user presses 'Cancel' when presented with '... wants to use facebook.com to sign in'.
//            if let result = result,
//               result.isCancelled {
//                completion(Constants.Errors.operationTerminatedByTheUser, false, nil, false)
//                return
//            }
            
            let request = GraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, middle_name, last_name"])
            request.start { connection, requestResult, error in
                if let error = error {
                    print("ERROR SIGNING IN WITH FACEBOOK \(error)")
                    completion(Constants.Alerts.Messages.unsuccessfulSignUpUserUnknown, false, nil, false)
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                guard let requestResult = requestResult as? [String: String],
                      let email = requestResult["email"] else { return }
                                
                Auth.auth().signIn(with: credential) { authResult, error in
                   
                    if let error = error as? AuthErrorCode {
                        self.determineProvider(for: email) { [weak self] provider in
                            print("AUTH ERROR: \(error.errorCode)\n \(error)")
                            
                            self?.determineProvider(for: email) { provider in
                                if(provider == Constants.Providers.noProvider) {
                                    /// This indicates that the email address is not in use. Something else is wrong.
                                    completion(error.localizedDescription, false, nil, false)
                                } else if(provider == Constants.Providers.emailPassword) {
                                    /// The user previously signed up with email address and password.
                                    completion(Constants.Alerts.Messages.unsuccessfulSignUpUserAlreadyExists, false, nil, false)
                                } else if(provider != Constants.Providers.facebook) {
                                    /// The user previously signed up with a different provider
                                    completion(Constants.Alerts.Messages.loginWithDifferentProvider.replacingOccurrences(of: "***", with: provider), false, nil, false)
                                }
                            }
                        }
                    }
                    
                    if let authResult = authResult,
                       let isNewUser = authResult.additionalUserInfo?.isNewUser {
                        let user = authResult.user
                        
                        if(isNewUser) {
                            /// If the user has signed in with Facebook for the first time, fetch user's data from Facebook
                            let userModel = UserModel(uid: authResult.user.uid,
                                                      providerName: Constants.Providers.facebook,
                                                      firstName: requestResult["first_name"],
                                                      middleName: requestResult["middle_name"],
                                                      lastName: requestResult["last_name"],
                                                      email: email)
                            completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                        } else {
                            /// If this is a returning user, then fetch user's data from Firebase Realtime Database
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .short
                            
                            FirebaseRealtimeDatabaseManager.shared.fetchUserProfileFromFirebaseDatabase(uid: user.uid) { userProfile in
                                let userModel = UserModel(uid: user.uid,
                                                          providerName: userProfile?["providerName"] as? String,
                                                          firstName: userProfile?["firstName"] as? String,
                                                          middleName: userProfile?["middleName"] as? String,
                                                          lastName: userProfile?["lastName"] as? String,
                                                          age: userProfile?["age"] as? Int,
                                                          gender: userProfile?["gender"] as? String,
                                                          email: userProfile?["email"] as! String,
                                                          phoneNumber: userProfile?["phoneNumber"] as? String,
                                                          dateOfBirth: dateFormatter.date(from: userProfile?["dateOfBirth"] as! String),
                                                          city: userProfile?["city"] as? String,
                                                          state: userProfile?["state"] as? String,
                                                          country: userProfile?["country"] as? String,
                                                          profilePhotoFirebaseStorageURL: userProfile?["profilePhotoFirebaseStorageURL"] as? String)
                                completion(Constants.Alerts.Messages.successfulSignIn, true, userModel, isNewUser)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sign Out
    /// Signs users out.
    ///
    /// - The parameter `completion` has two arguments:
    ///     1. `String`: If the user was successfully signed out, this argument contains a success message. Otherwise, it contains the reason why the sign out process failed.
    ///     2. `Bool`: Indicating whether the user was signed out or not.
    ///
    /// - Parameter completion: An escaping closure with two arguments
    ///
    func signOut(provider: String, completion: @escaping (String, Bool) -> Void) {
        if(provider == Constants.Providers.google) {
            GIDSignIn.sharedInstance.signOut()
        } else if (provider ==  Constants.Providers.facebook) {
            facebookLoginManager.logOut()
        }
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(Constants.Alerts.Messages.successfulSignOut, true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(Constants.Alerts.Messages.unsuccessfulSignOut, false)
        }
    }
}
