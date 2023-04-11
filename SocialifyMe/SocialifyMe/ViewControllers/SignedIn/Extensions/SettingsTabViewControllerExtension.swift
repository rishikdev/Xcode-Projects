//
//  HelperFunctionsSignedInSettingsViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 03/03/23.
//

import UIKit

extension SettingsTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func initialConfiguration() {
        self.navigationItem.title =  Constants.VCTitles.settingsTabVC
        self.settingsTabVM = SettingsTabViewModel(firebaseAuthenticationManager: FirebaseAuthenticationManager.shared,
                                                  firebaseRealtimeDatabaseManager: FirebaseRealtimeDatabaseManager.shared,
                                                  coreDataManager: CoreDataManager.shared)
        
        configureButton(button: buttonEditProfile, buttonTitle: Constants.Buttons.editProfile, buttonColour: .systemBlue)
        configureButton(button: buttonSignOut, buttonTitle: Constants.Buttons.signOut, buttonColour: .systemRed)
        configureCollectionView()
        self.labelPostFetchInfo.isHidden = true
    }
    
    private func configureButton(button: UIButton, buttonTitle: String, buttonColour: UIColor) {
        button.configuration = .tinted()
        button.configuration?.title = buttonTitle
        button.configuration?.baseBackgroundColor = buttonColour
        button.configuration?.baseForegroundColor = buttonColour
    }
    
    private func configureCollectionView() {
        self.collectionViewUserPosts.delegate = self
        self.collectionViewUserPosts.dataSource = self
    }
    
    func populateFields() {
        guard let sharedLocalUser = SharedUser.shared.localUser else { return }
        
        if(sharedLocalUser.profilePhotoLocalStorageURL != nil) {
            DispatchQueue.main.async {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = documentsURL.appendingPathComponent(Constants.ProfilePhoto.name + Constants.ProfilePhoto.extn).path
                if FileManager.default.fileExists(atPath: filePath) {
                    self.imageViewProfilePhoto.image = UIImage(contentsOfFile: filePath)
                    self.imageViewProfilePhoto.roundImage()
                }
            }
        } else {
            self.imageViewProfilePhoto.load(Constants.DefaultURLs.noProfilePhoto)
            self.imageViewProfilePhoto.roundImage()
        }
        
        labelPosts.text = Constants.LabelTexts.labelPosts
        labelFollowers.text = Constants.LabelTexts.labelFollowers
        labelFollowing.text = Constants.LabelTexts.labelFollowing
        
        labelPostCount.text = "\(self.settingsTabVM.posts.count)"
        labelFollowersCount.text = "0"
        labelFollowingCount.text = "0"
        labelUserName.text = sharedLocalUser.firstName! + " " + (sharedLocalUser.middleName ?? "") + " " + (sharedLocalUser.lastName ?? "")
        labelYourPosts.text = Constants.LabelTexts.labelYourPosts
        fetchPosts()
    }
    
    private func fetchPosts() {
        let activityIndicator = self.addActivityIndicator()
        settingsTabVM.fetchPostsMetadataFromFirebaseDatabaseFor(uid: (SharedUser.shared.localUser?.uid)!) { [weak self] fetchMessage, isFetchSuccessful in
            self?.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if(isFetchSuccessful) {
                self?.labelPostCount.text = "\(self?.settingsTabVM.posts.count ?? 0)"
                if(self!.settingsTabVM.posts.count == 0) {
                    self?.labelPostFetchInfo.text = Constants.LabelTexts.labelNoPosts
                    self?.labelPostFetchInfo.isHidden = false
                } else {
                    self?.labelPostFetchInfo.isHidden = true
                }
                self?.collectionViewUserPosts.reloadData()
            } else {
                self?.labelPostFetchInfo.text = Constants.LabelTexts.labelPostError
                self?.labelPostFetchInfo.isHidden = false
                self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: fetchMessage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.settingsTabVM.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? PostPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        postCell.imageViewPostPhoto.load(self.settingsTabVM.posts[indexPath.row].postPhotoStorageURL ?? Constants.DefaultURLs.noPostPhoto)
        postCell.imageViewPostPhoto.layer.cornerRadius = 10
        
        return postCell
    }
    
    func editProfile() {
        guard let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else { return }
        
        editProfileVC.dateOfBirth = SharedUser.shared.localUser?.dateOfBirth
        
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    func signOut() {
        guard let signedOutHomeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignedOutHomeNavigationController") as? UINavigationController else { return }
        
        presentSignOutAlert(title: Constants.Alerts.Titles.confirmation, message: Constants.Alerts.Messages.signOutMessage, switchTo: signedOutHomeNavigationController)
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
        alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default))
        
        present(alertController, animated: true)
    }
    
    private func presentSignOutAlert(title: String, message: String, switchTo viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.signOut, style: .destructive) { _ in
            DispatchQueue.main.async {
                self.settingsTabVM.signOut(provider: (SharedUser.shared.localUser?.providerName)!) { [weak self] message, isSignedOut in
                    if(isSignedOut) {
                        self?.settingsTabVM.deleteAllLocalUsers(entity: Constants.CoreData.entityLocalUser)
                        self?.switchRootViewController(to: viewController)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: Constants.Buttons.cancel, style: .cancel))
        present(alertController, animated: true)
    }
}
