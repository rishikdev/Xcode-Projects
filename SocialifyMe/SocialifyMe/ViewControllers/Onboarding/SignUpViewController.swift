//
//  ViewController.swift
//  SignUp
//
//  Created by Rishik Dev on 21/02/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelMiddleName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelDateOfBirth: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldMiddleName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var buttonSelectGender: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var datePickerDateOfBirth: UIDatePicker!
    @IBOutlet weak var labelAgeValue: UILabel!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldCountry: UITextField!
    @IBOutlet weak var stackViewEmailPassword: UIStackView!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    var editProfileVM: EditProfileViewModel?
    var dateOfBirth: Date?
    var genderMenu: UIMenu!
    var selectedGender: Constants.Genders!
    var sharedLocalUser: LocalUser?
    var email: String?
    var password: String?
    
    var profilePhotoURLPath: URL?
    var didUserCancelProfilePhotoSelection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(sharedLocalUser != nil) {
            configureFederatedSignUp()
        } else {
            configureNonFederatedSignUp()
        }
    }
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) {
        signUpHandler()
    }
    
    @IBAction func dateOfBirthAction(_ sender: UIDatePicker) {
        dateOfBirth = datePickerDateOfBirth.date
        labelAgeValue.text = "\(ValidateData.shared.isValidDateOfBirth(value: dateOfBirth ?? Date()).1 ?? 0)"
    }
}
