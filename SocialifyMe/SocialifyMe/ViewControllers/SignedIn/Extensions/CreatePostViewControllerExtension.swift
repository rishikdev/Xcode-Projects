//
//  HelperFunctionsCreatePostViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 14/03/23.
//

import UIKit

protocol CreatePostVCProtocol {
    func reloadHomeVC()
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func initialConfiguration() {
        self.labelCreatePost.text = Constants.VCTitles.createPostVC
        self.stackViewMain.layer.cornerRadius = 10
        self.imageViewSelectedPhoto.isHidden = true
        self.buttonPost.isEnabled = false
        configureTextView()
        
        self.createPostVM = CreatePostViewModel(firebaseStorageManager: FirebaseStorageManager.shared)
        
        configureButtons(button: buttonCancel, buttonTitle: Constants.Buttons.cancel, buttonColour: .red)
        configureButtons(button: buttonPost, buttonTitle: Constants.Buttons.post, buttonColour: .systemBlue)
        configureButtons(button: buttonSelectPhoto, buttonTitle: Constants.Buttons.selectPhoto, buttonColour: .systemPurple)
    }
    
    private func configureTextView() {
        self.textViewPostDescription.layer.cornerRadius = 10
        self.textViewPostDescription.layer.borderWidth = 1
        self.textViewPostDescription.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    private func configureButtons(button: UIButton, buttonTitle: String, buttonColour: UIColor) {
        button.configuration = .tinted()
        button.configuration?.title = buttonTitle
        button.configuration?.baseBackgroundColor = buttonColour
        button.configuration?.baseForegroundColor = buttonColour
    }
    
    func selectPhotoHandler() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedPhoto = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.imageViewSelectedPhoto.isHidden = false
        self.imageViewSelectedPhoto.image = selectedPhoto
        self.imageViewSelectedPhoto.layer.cornerRadius = 10
        
        self.buttonPost.isEnabled = true
        
        self.postPhotoURLPath = getDocumentsDirectory().appendingPathComponent("post")
        
        guard let jpegData = selectedPhoto.jpegData(compressionQuality: 0.8) else { return }
        try? jpegData.write(to: self.postPhotoURLPath!)
        
        dismiss(animated: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func uploadPost() {
        if let postPhotoURLPath = postPhotoURLPath {
            let activityIndicator = self.addActivityIndicator()
            self.createPostVM.uploadPostToFirebaseStorage(user: SharedUser.shared.localUser!, from: postPhotoURLPath, description: textViewPostDescription.text) { [weak self] postUploadMessage, isPostUploaded in
                self?.removeActivityIndicator(activityIndicator: activityIndicator)
                if(isPostUploaded) {
                    self?.presentAlert(title: Constants.Alerts.Titles.successful, message: Constants.Alerts.Messages.successfulPostUpload)
                } else {
                    self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: Constants.Alerts.Messages.unsuccessfulPostUpload)
                }
            }
        } else {
            self.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: Constants.Alerts.Messages.unsuccessfulPostUpload)
        }
    }
    
    func dismissView() {
        dismiss(animated: true)
    }
    
    private func addActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    private func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default) { _ in
            guard let delegate = self.delegate else { return }
            delegate.reloadHomeVC()
            self.dismissView()
        })
        
        present(alertController, animated: true)
    }
}
