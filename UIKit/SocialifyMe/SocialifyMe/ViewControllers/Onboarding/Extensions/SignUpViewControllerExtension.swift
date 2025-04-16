//
//  HelperFunctionsExtension.swift
//  UserLogin
//
//  Created by Rishik Dev on 27/02/23.
//

import UIKit
import FirebaseDatabase

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func initialConfiguration() {
        title = Constants.VCTitles.signUpVCTitle
        configureProfilePhoto()
        setDatePicker()
        configureButtonSelectGender()
        populateLabelsAndTextFieldPlaceholders()
        self.editProfileVM = EditProfileViewModel(firebaseAuthenticationManager: FirebaseAuthenticationManager.shared,
                                                  firebaseStorageManager: FirebaseStorageManager.shared,
                                                  firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManager.shared,
                                                  coreDataManager: CoreDataManager.shared)
    }
    
    func populateLabelsAndTextFieldPlaceholders() {
        labelFirstName.text = Constants.LabelTexts.firstName
        labelMiddleName.text = Constants.LabelTexts.middleName
        labelLastName.text = Constants.LabelTexts.lastName
        labelGender.text = Constants.LabelTexts.gender
        labelEmail.text = Constants.TextFieldPlaceholders.email
        labelPassword.text = Constants.TextFieldPlaceholders.password
        labelPhoneNumber.text = Constants.LabelTexts.phoneNumber
        labelAge.text = Constants.LabelTexts.age
        labelDateOfBirth.text = Constants.LabelTexts.dateOfBirth
        labelCity.text = Constants.LabelTexts.city
        labelState.text = Constants.LabelTexts.state
        labelCountry.text = Constants.LabelTexts.country
        
        textFieldFirstName.placeholder = Constants.TextFieldPlaceholders.firstName
        textFieldMiddleName.placeholder = Constants.TextFieldPlaceholders.middleName
        textFieldLastName.placeholder = Constants.TextFieldPlaceholders.lastName
        textFieldEmail.placeholder = Constants.TextFieldPlaceholders.email
        textFieldPassword.placeholder = Constants.TextFieldPlaceholders.password
        textFieldConfirmPassword.placeholder = Constants.TextFieldPlaceholders.confirmPassword
        textFieldPhoneNumber.placeholder = Constants.TextFieldPlaceholders.phoneNumber
        textFieldCity.placeholder = Constants.TextFieldPlaceholders.city
        textFieldState.placeholder = Constants.TextFieldPlaceholders.state
        textFieldCountry.placeholder = Constants.TextFieldPlaceholders.country
    }
    
    func configureNonFederatedSignUp() {
         if(sharedLocalUser == nil) {
            self.stackViewEmailPassword.isHidden = false

             buttonSignUp.configuration?.title = Constants.Buttons.signUp
            
             if let email = email {
                textFieldEmail.text = email
            }
            
            if let password = password {
                textFieldPassword.text = password
                textFieldConfirmPassword.text = password
            }
        }
    }
    
    func configureFederatedSignUp() {
        if let user = sharedLocalUser {
            self.stackViewEmailPassword.isHidden = true
            
            buttonSignUp.configuration?.title = Constants.Buttons.updateProfile
            textFieldEmail.text = user.email
            textFieldFirstName.text = user.firstName
            textFieldMiddleName.text = user.middleName
            textFieldLastName.text = user.lastName
        }
    }
    
    func configureProfilePhoto() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfilePhotoTap(tapGestureREcognizer:)))
        imageViewProfilePhoto.isUserInteractionEnabled = true
        imageViewProfilePhoto.addGestureRecognizer(tapGestureRecognizer)
        imageViewProfilePhoto.roundImage()
    }
    
    func setDatePicker() {
        datePickerDateOfBirth.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        labelAgeValue.text = "0"
    }
    
    func configureButtonSelectGender() {
        genderMenu = generateGenderMenu()
        selectedGender = .male
        buttonSelectGender.menu = genderMenu
        buttonSelectGender.showsMenuAsPrimaryAction = true
        changeButtonSelectGender(to: selectedGender)
    }
    
    func changeButtonSelectGender(to gender: Constants.Genders) {
        buttonSelectGender.configuration = .tinted()
        
        switch(gender) {
        case .male:
            buttonSelectGender.configuration?.title = Constants.GendersString.male
            buttonSelectGender.configuration?.baseBackgroundColor = .systemBlue
            buttonSelectGender.configuration?.baseForegroundColor = .systemBlue
            
        case .female:
            buttonSelectGender.configuration?.title = Constants.GendersString.female
            buttonSelectGender.configuration?.baseBackgroundColor = .systemPink
            buttonSelectGender.configuration?.baseForegroundColor = .systemPink
            
        case .other:
            buttonSelectGender.configuration?.title = Constants.GendersString.other
            buttonSelectGender.configuration?.baseBackgroundColor = .systemGray
            buttonSelectGender.configuration?.baseForegroundColor = .systemGray
        }
    }
    
    func generateGenderMenu() -> UIMenu {
        var menuItems: [UIAction] {
            return [
                UIAction(title: Constants.GendersString.male, handler: { (_) in self.selectedGender = .male
                    self.changeButtonSelectGender(to: self.selectedGender)
                }),
                UIAction(title: Constants.GendersString.female, handler: { (_) in self.selectedGender = .female
                    self.changeButtonSelectGender(to: self.selectedGender)
                }),
                UIAction(title: Constants.GendersString.other, handler: { (_) in self.selectedGender = .other
                    self.changeButtonSelectGender(to: self.selectedGender)
                })
            ]
        }

        var genderMenu: UIMenu {
            return UIMenu(title: Constants.Buttons.gender, image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        return genderMenu
    }
    
    @objc func handleProfilePhotoTap(tapGestureREcognizer: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profilePhoto = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageViewProfilePhoto.image = profilePhoto
        self.profilePhotoURLPath = getDocumentsDirectory().appendingPathComponent(Constants.ProfilePhoto.name)
        
        guard let jpegData = profilePhoto.jpegData(compressionQuality: 0.8) else { return }
        try? jpegData.write(to: self.profilePhotoURLPath!)
        self.didUserCancelProfilePhotoSelection = false
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.didUserCancelProfilePhotoSelection = true
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func registerUser(providerName: String, completion: @escaping (String, Bool) -> Void) {
        guard let firstName = textFieldFirstName.text,
              ValidateData.shared.isValidFirstName(value: firstName) else { completion(Constants.Alerts.Messages.firstName, false); return }
        
        guard let lastName = textFieldLastName.text,
              ValidateData.shared.isValidLastName(value: lastName) else { completion(Constants.Alerts.Messages.lastName, false); return }
        
        guard let email = textFieldEmail.text,
              email != "" else { completion(Constants.Alerts.Messages.unsuccessfulSignIn, false); return }
        
        guard let password = textFieldPassword.text,
              let confirmedPassword = textFieldConfirmPassword.text,
              ValidateData.shared.arePasswordsMatching(password: password, confirmedPassword: confirmedPassword) else { completion(Constants.Alerts.Messages.passwordMismatch, false); return }
        
        guard let phoneNumber = textFieldPhoneNumber.text,
              ValidateData.shared.isValidPhoneNumber(value: phoneNumber) else { completion(Constants.Alerts.Messages.phoneNumber, false); return }
        
        guard let dateOfBirth = dateOfBirth,
              ValidateData.shared.isValidDateOfBirth(value: dateOfBirth).0,
              let age = ValidateData.shared.isValidDateOfBirth(value: dateOfBirth).1 else { completion(Constants.Alerts.Messages.dateOfBirth, false); return }
        
        guard let city = textFieldCity.text,
              ValidateData.shared.isValidCity(value: city) else { completion(Constants.Alerts.Messages.city, false); return }
        
        guard let state = textFieldState.text,
              ValidateData.shared.isValidState(value: state) else { completion(Constants.Alerts.Messages.state, false); return }
        
        guard let country = textFieldCountry.text,
              ValidateData.shared.isValidCountry(value: country) else { completion(Constants.Alerts.Messages.country, false); return }
        
        var userModel = UserModel(uid: "",
                                  providerName: providerName,
                                  firstName: firstName,
                                  middleName: self.textFieldMiddleName.text,
                                  lastName: lastName,
                                  age: age,
                                  gender: getSelectedGenderString(from: self.selectedGender),
                                  email: email,
                                  phoneNumber: phoneNumber,
                                  dateOfBirth: dateOfBirth,
                                  city: city,
                                  state: state,
                                  country: country)
        
        /// Signing up with Google or Facebook
        if let localUser = sharedLocalUser,
           let uid = localUser.uid {
            userModel.uid = uid
            
            if !didUserCancelProfilePhotoSelection,
               let profilePhotoURLPath = profilePhotoURLPath {
                self.editProfileVM?.uploadProfilePhotoToFirebaseStorage(uid: uid, from: profilePhotoURLPath) { [weak self] uploadProfilePhotoMessage, downloadURL, isProfilePhotoUploaded in
                    if(isProfilePhotoUploaded) {
                        userModel.profilePhotoFirebaseStorageURL = downloadURL
                        self?.editProfileVM?.updateUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] updateProfileMessage, isProfileUpdated, updatedUserModel in
                            if(isProfileUpdated) {
                                /// Profile was successfully updated
                                self?.editProfileVM?.downloadProfilePhotoFromFirebaseStorage(uid: uid) { [weak self] downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                                    if(isProfilePhotoDownloaded) {
                                        /// Profile photo was successfully uploaded and downloaded to local storage
                                        self?.editProfileVM?.updateUserProfileInLocalStorage(localUser: localUser, updatedUserModel: updatedUserModel, profilePhotoURL: downloadedProfilePhotoURL)
                                        completion(updateProfileMessage, true)
                                    } else {
                                        /// Profile photo was successfully uploaded, but could not be downloaded to local storage
                                        self?.editProfileVM?.updateUserProfileInLocalStorage(localUser: localUser, updatedUserModel: updatedUserModel, profilePhotoURL: nil)
                                        completion(Constants.Alerts.Messages.successfulProfileUpdationUnsuccessfulProfilePhotoUpload, true)
                                    }
                                }
                            } else {
                                /// Profile could not be updated
                                completion(updateProfileMessage, false)
                            }
                        }
                    } else {
                        /// Profile photo could not be uploaded
                        completion(Constants.Alerts.Messages.unsuccessfulProfileUpdation, false)
                    }
                }
            } else {
                /// User did not choose a profile photo or there was something wrong with the selected profile photo
                self.editProfileVM?.updateUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] updateProfileMessage, isProfileUpdated, updatedUserModel in
                    if(isProfileUpdated) {
                        /// Profile was successfully updated
                        self?.editProfileVM?.updateUserProfileInLocalStorage(localUser: localUser, updatedUserModel: updatedUserModel, profilePhotoURL: nil)
                        completion(updateProfileMessage, true)
                    } else {
                        /// Profile could not be updated
                        completion(updateProfileMessage, false)
                    }
                }
            }
            
        } else {
            /// Signing up with Email
            ///
            /// First create an account, then create a profile using details obtained from the created account. Also create a local account for the user.
            ///
            editProfileVM?.createAccount(email: email, password: password) { [weak self] createAccountMessage, isAccountCreated, user in
                if(isAccountCreated),
                  let uid = user?.uid {
                    userModel.uid = uid
                    
                    if !self!.didUserCancelProfilePhotoSelection,
                       let profilePhotoURLPath = self?.profilePhotoURLPath {
                        self?.editProfileVM?.uploadProfilePhotoToFirebaseStorage(uid: uid, from: profilePhotoURLPath) { [weak self] uploadProfilePhotoMessage, downloadURL, isProfilePhotoUploaded in
                            if(isProfilePhotoUploaded) {
                                userModel.profilePhotoFirebaseStorageURL = downloadURL
                                self?.editProfileVM?.createUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] createProfileMessage , isProfileCreated in
                                    if(isProfileCreated) {
                                        self?.editProfileVM?.downloadProfilePhotoFromFirebaseStorage(uid: uid) { [weak self] downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                                            if(isProfilePhotoDownloaded) {
                                                /// Profile photo was successfully uploaded and downloaded to local storage
                                                self?.editProfileVM?.createUserProfileInLocalStorage(userModel: userModel, profilePhotoURL: downloadedProfilePhotoURL)
                                                completion(createProfileMessage, true)
                                            } else {
                                                /// Profile photo was successfully uploaded, but could not be downloaded to local storage
                                                self?.editProfileVM?.createUserProfileInLocalStorage(userModel: userModel, profilePhotoURL: nil)
                                                completion(Constants.Alerts.Messages.successfulProfileCreationUnsuccessfulProfilePhotoUpload, true)
                                            }
                                        }
                                    } else {
                                        /// Profile could not be created
                                        self?.editProfileVM?.createUserProfileInLocalStorage(userModel: userModel, profilePhotoURL: nil)
                                        completion(Constants.Alerts.Messages.successfulSignUpUnsuccessfulProfileCreation, true)
                                    }
                                }
                            } else {
                                /// Profile photo could not be uploaded
                                self?.editProfileVM?.createUserProfileInLocalStorage(userModel: userModel, profilePhotoURL: nil)
                                completion(Constants.Alerts.Messages.successfulSignUpUnsuccessfulProfileCreation, true)
                            }
                        }
                    } else {
                        /// User did not choose a profile photo or there was something wrong with the selected profile photo
                        self?.editProfileVM?.createUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] createProfileMessage, isProfileCreated in
                            if(isProfileCreated) {
                                self?.editProfileVM?.createUserProfileInLocalStorage(userModel: userModel, profilePhotoURL: nil)
                                completion(createProfileMessage, true)
                            } else {
                                self?.editProfileVM?.createUserProfileInLocalStorage(userModel: userModel, profilePhotoURL: nil)
                                completion(Constants.Alerts.Messages.successfulSignUpUnsuccessfulProfileCreation, true)
                            }
                        }
                    }
                } else {
                    /// Account could not be created
                    completion(createAccountMessage, false)
                }
            }
        }
    }
    
    func signUpHandler() {
        let activityIndicator = addActivityIndicator()
        registerUser(providerName: Constants.Providers.emailPassword) { [weak self] message, isRegistrationSuccessful in
            guard let signedInTabBarController = UIStoryboard(name: "SignedIn", bundle: nil).instantiateViewController(withIdentifier: "SignedInTabBarController") as? SignedInTabBarController else { return }
            
            DispatchQueue.main.async {
                self?.removeActivityIndicator(activityIndicator: activityIndicator)
                
                if(isRegistrationSuccessful) {
                    /// This indicates that the user created his/her account using a provider such as Google or Facebook
                    if(self?.sharedLocalUser != nil) {
                        self?.presentAlertAndSwitchVC(title: Constants.Alerts.Titles.successful, message: message, switchTo: signedInTabBarController)
                    } else {
                        self?.presentAlert(title: Constants.Alerts.Titles.successful, message: message, navigateBack: true)
                    }
                } else {
                    self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: message)
                }
            }
        }
    }
    
    func addActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func presentAlert(title: String, message: String, navigateBack: Bool = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(navigateBack) {
            alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default))
        }
        present(alertController, animated: true)
    }
    
    func presentAlertAndSwitchVC(title: String, message: String, switchTo viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default) { _ in
            self.switchRootViewController(to: viewController)
        })
        present(alertController, animated: true)
    }
    
    func getSelectedGenderString(from selectedGender: Constants.Genders) -> String {
        var genderString = ""
        
        switch(selectedGender) {
            case .male:
                genderString = Constants.GendersString.male
                
            case .female:
                genderString = Constants.GendersString.female
                
            case .other:
                genderString = Constants.GendersString.other
        }
        
        return genderString
    }
}
