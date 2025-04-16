//
//  HelperFunctionsEditDetailsViewExtension.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 02/03/23.
//

import UIKit

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func initialConfiguration() {
        populateLabelsAndTextFieldPlaceholders()
        configureProfilePhoto()
        addSaveButton()
        setDatePicker()
        configureButtonSelectGender()
        convertStringGenderToEnumGender(stringGender: SharedUser.shared.localUser?.gender ?? Constants.Genders.male.rawValue)
        populateTextFields()
        
        self.isNewProfilePhotoSelected = false
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
        labelPhoneNumber.text = Constants.LabelTexts.phoneNumber
        labelAgeValue.text = Constants.LabelTexts.age
        labelDateOfBirth.text = Constants.LabelTexts.dateOfBirth
        labelCity.text = Constants.LabelTexts.city
        labelState.text = Constants.LabelTexts.state
        labelCountry.text = Constants.LabelTexts.country
        
        textFieldFirstName.placeholder = Constants.TextFieldPlaceholders.firstName
        textFieldMiddleName.placeholder = Constants.TextFieldPlaceholders.middleName
        textFieldLastName.placeholder = Constants.TextFieldPlaceholders.lastName
        textFieldEmail.placeholder = Constants.TextFieldPlaceholders.email
        textFieldPhoneNumber.placeholder = Constants.TextFieldPlaceholders.phoneNumber
        textFieldCity.placeholder = Constants.TextFieldPlaceholders.city
        textFieldState.placeholder = Constants.TextFieldPlaceholders.state
        textFieldCountry.placeholder = Constants.TextFieldPlaceholders.country
    }
    
    func configureProfilePhoto() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfilePhotoTap(tapGestureREcognizer:)))
        imageViewProfilePhoto.isUserInteractionEnabled = true
        imageViewProfilePhoto.addGestureRecognizer(tapGestureRecognizer)
        imageViewProfilePhoto.roundImage()
    }
    
    func addSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.Buttons.save, style: .done, target: self, action: #selector(buttonSaveAction))
    }
    
    func populateTextFields() {
        guard let sharedLocalUser = SharedUser.shared.localUser else { return }
        
        if(sharedLocalUser.profilePhotoLocalStorageURL != nil) {
            DispatchQueue.main.async {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = documentsURL.appendingPathComponent(Constants.ProfilePhoto.name + Constants.ProfilePhoto.extn).path
                if FileManager.default.fileExists(atPath: filePath) {
//                    self.profilePhotoURLPath = URL(string: filePath)
                    self.imageViewProfilePhoto.image = UIImage(contentsOfFile: filePath)
                }
            }
        }
        
        textFieldFirstName.text = sharedLocalUser.firstName
        textFieldMiddleName.text = sharedLocalUser.middleName ?? ""
        textFieldLastName.text = sharedLocalUser.lastName
        changeButtonSelectGender(to: selectedGender)
        textFieldEmail.text = sharedLocalUser.email
        textFieldPhoneNumber.text = sharedLocalUser.phoneNumber
        labelAgeValue.text = "\(sharedLocalUser.age)"
        datePickerDateOfBirth.date = sharedLocalUser.dateOfBirth ?? Date()
        textFieldCity.text = sharedLocalUser.city
        textFieldState.text = sharedLocalUser.state
        textFieldCountry.text = sharedLocalUser.country
    }
    
    func setDatePicker() {
        datePickerDateOfBirth.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
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
    
    func convertStringGenderToEnumGender(stringGender: String) {
        if(stringGender == Constants.Genders.male.rawValue) {
            self.selectedGender = Constants.Genders.male
        } else if(stringGender == Constants.Genders.female.rawValue) {
            self.selectedGender = Constants.Genders.female
        } else if(stringGender == Constants.Genders.other.rawValue) {
            self.selectedGender = Constants.Genders.other
        } else {
            self.selectedGender = Constants.Genders.male
        }
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
        self.isNewProfilePhotoSelected = true
        
        guard let jpegData = profilePhoto.jpegData(compressionQuality: 0.8) else { return }
        try? jpegData.write(to: self.profilePhotoURLPath!)
                
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveChangesToProfile(completion: @escaping (String, Bool) -> Void) {
        guard let firstName = textFieldFirstName.text,
              ValidateData.shared.isValidFirstName(value: firstName) else { completion(Constants.Alerts.Messages.firstName, false); return }
        
        guard let lastName = textFieldLastName.text,
              ValidateData.shared.isValidLastName(value: lastName) else { completion(Constants.Alerts.Messages.lastName, false); return }
        
        guard let email = textFieldEmail.text,
              email != "" else { completion(Constants.Alerts.Messages.unsuccessfulSignIn, false); return }
        
        
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
        
        let sharedLocalUser = SharedUser.shared.localUser!
        
        var userModel = UserModel(uid: sharedLocalUser.uid!,
                                  providerName: sharedLocalUser.providerName,
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
                                  country: country,
                                  profilePhotoFirebaseStorageURL: SharedUser.shared.localUser?.profilePhotoFirebaseStorageURL)
        
        if self.isNewProfilePhotoSelected,
           let profilePhotoURLPath = self.profilePhotoURLPath,
           let uid = sharedLocalUser.uid {
            self.editProfileVM?.uploadProfilePhotoToFirebaseStorage(uid: uid, from: profilePhotoURLPath) { [weak self] uploadProfilePhotoMessage, downloadURL, isProfilePhotoUploaded in
                if(isProfilePhotoUploaded) {
                    userModel.profilePhotoFirebaseStorageURL = downloadURL
                    self?.editProfileVM?.updateUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] updateProfileMessage, isProfileUpdated, updatedUserModel in
                        if(isProfileUpdated) {
                            /// Profile was successfully updated
                            self?.editProfileVM?.downloadProfilePhotoFromFirebaseStorage(uid: uid) { [weak self] downloadedProfilePhotoURL, isProfilePhotoDownloaded in
                                if(isProfilePhotoDownloaded) {
                                    /// Profile photo was successfully uploaded and downloaded to local storage
                                    self?.editProfileVM?.updateUserProfileInLocalStorage(localUser: sharedLocalUser, updatedUserModel: updatedUserModel, profilePhotoURL: downloadedProfilePhotoURL)
                                    completion(updateProfileMessage, true)
                                } else {
                                    /// Profile photo was successfully uploaded, but could not be downloaded to local storage
                                    self?.editProfileVM?.updateUserProfileInLocalStorage(localUser: sharedLocalUser, updatedUserModel: updatedUserModel, profilePhotoURL: nil)
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
                    self?.editProfileVM?.updateUserProfileInLocalStorage(localUser: sharedLocalUser, updatedUserModel: updatedUserModel, profilePhotoURL: sharedLocalUser.profilePhotoLocalStorageURL)
                    completion(updateProfileMessage, true)
                } else {
                    /// Profile could not be updated
                    completion(updateProfileMessage, false)
                }
            }
        }
    }
    
    func saveHandler() {
        let activityIndicator = addActivityIndicator()
        self.saveChangesToProfile { [weak self] message, isProfileUpdated in
            self?.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if(isProfileUpdated) {
                self?.presentAlert(title: Constants.Alerts.Titles.successful, message: message, navigateBack: true)
            } else {
                self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: message)
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
