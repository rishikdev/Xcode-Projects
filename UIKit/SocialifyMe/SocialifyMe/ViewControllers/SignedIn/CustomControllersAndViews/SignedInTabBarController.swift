//
//  SignedInTabBarController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SignedInTabBarController: UITabBarController {
    
    var databaseRef: DatabaseReference?
    var storageRef: StorageReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        guard let tabBarItems = tabBar.items else { return }
        
        tabBarItems[0].title = Constants.TabBarTitles.homeTab
        tabBarItems[1].title = Constants.TabBarTitles.exploreTab
        tabBarItems[2].title = Constants.TabBarTitles.messagesTab
        tabBarItems[3].title = Constants.TabBarTitles.settingsTab
        
//        if let homeNavigationController = viewControllers?[0] as? UINavigationController {
//            let homeVC = homeNavigationController.topViewController as! HomeTabViewController
//            homeVC.sharedUser = sharedUser
//        }
    }
}
