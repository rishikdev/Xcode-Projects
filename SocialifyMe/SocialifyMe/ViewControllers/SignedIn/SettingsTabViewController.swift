//
//  SignedInSettingsViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SettingsTabViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var labelPostCount: UILabel!
    @IBOutlet weak var labelPosts: UILabel!
    @IBOutlet weak var labelFollowersCount: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet weak var labelFollowingCount: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var buttonSignOut: UIButton!
    @IBOutlet weak var labelYourPosts: UILabel!
    @IBOutlet weak var labelPostFetchInfo: UILabel!
    @IBOutlet weak var collectionViewUserPosts: UICollectionView!
    
    var settingsTabVM: SettingsTabViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateFields()
    }
    
    @IBAction func buttonEditProfileAction(_ sender: Any) {
        editProfile()
    }
    
    @IBAction func buttonSignOutAction(_ sender: Any) {
        signOut()
    }
}
