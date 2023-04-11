//
//  SignedInHomeViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit

class HomeTabViewController: UIViewController {
        
    @IBOutlet weak var labelNoContent: UILabel!
    
    var homeTabVM: HomeTabViewModel!
    var postPhotoURLPath: URL?
                
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
    }
}
