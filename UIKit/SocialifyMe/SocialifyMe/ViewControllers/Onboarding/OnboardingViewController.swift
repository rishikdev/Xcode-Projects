//
//  ViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 28/02/23.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FirebaseDatabase
import FirebaseStorage

class OnboardingViewController: UIViewController {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonSignInWithGoogle: UIButton!
    @IBOutlet weak var buttonSignInWithFacebook: UIButton!
    @IBOutlet weak var viewLogoBackground: UIView!
    
    var onboardingVM: OnboardingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textFieldEmail.text = ""
        textFieldPassword.text = ""
        
        changeTitleColour(to: UIColor.white)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLogoBackground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        changeTitleColour(to: UIColor.label)
    }
    
    @IBAction func buttonSignInWithEmailAction(_ sender: Any) {
        signInWithEmailPassword()
    }
    
    @IBAction func buttonSignUpAction(_ sender: Any) {
        signUpWithEmailPassword()
    }
    
    @IBAction func buttonSignInWithGoogleAction(_ sender: Any) {
        signInWithGoogle()
    }
    
    @IBAction func buttonSignInWithFacebookAction(_ sender: Any) {
        signInWithFacebook()
    }
    
    @IBAction func buttonCrashTestAction(_ sender: Any) {
        let alertConroller = UIAlertController(title: "Information", message: "Crashlytics has been disabled for now.", preferredStyle: .alert)
        alertConroller.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertConroller, animated: true)
        
        /// Uncomment the following two lines to make the application crash upon pressing the 'CRASH TEST' button
//        let values = [Int]()
//        let _ = values[0]
    }
}
