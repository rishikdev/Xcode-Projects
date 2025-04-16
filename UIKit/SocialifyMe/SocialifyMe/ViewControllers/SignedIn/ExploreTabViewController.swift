//
//  SignedInSearchViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit

class ExploreTabViewController: UIViewController {

    @IBOutlet weak var labelNoFriends: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        title =  Constants.TabBarTitles.exploreTab
//        labelNoFriends.text = Constants.LabelTexts.noFriends
    }
}
