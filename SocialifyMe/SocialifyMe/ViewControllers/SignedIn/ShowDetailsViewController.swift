//
//  ShowDetailsViewController.swift
//  SignUp
//
//  Created by Rishik Dev on 21/02/23.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelMiddleName: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelDateOfBirth: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    
    @IBOutlet weak var stackViewName: UIStackView!
    @IBOutlet weak var stackViewAgeGender: UIStackView!
    @IBOutlet weak var stackViewEmailPhone: UIStackView!
    @IBOutlet weak var stackViewLocation: UIStackView!
    
    var editProfileVM: EditProfileViewModel?
    var user: LocalUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        self.hideKeyboardWhenTappedAround()
        addEditButton()
        
        // Do any additional setup after loading the view.
        setStyleOfStackView(stackView: stackViewName)
        setStyleOfStackView(stackView: stackViewAgeGender)
        setStyleOfStackView(stackView: stackViewEmailPhone)
        setStyleOfStackView(stackView: stackViewLocation)
        
        if let user = user {
            populateLabels(user: user)
        }
    }
    
    func addEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(buttonEditAction))
    }
    
    func setStyleOfStackView(stackView: UIStackView) {
        
        stackView.layer.cornerRadius = 10
    }
    
    func populateLabels(user: LocalUser) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        labelFirstName.text = user.firstName
        labelMiddleName.text = user.middleName ?? ""
        labelLastName.text = user.lastName
        labelAge.text = "\(user.age)"
        labelGender.text = user.gender
        labelEmail.text = user.email
        labelPhoneNumber.text = user.phoneNumber
        labelDateOfBirth.text = "\(dateFormatter.string(from: user.dateOfBirth ?? Date()))"
        labelCity.text = user.city
        labelState.text = user.state
        labelCountry.text = user.country
    }
    
    @objc func buttonEditAction() {
        
        guard let editDetailsVC = storyboard?.instantiateViewController(withIdentifier: "EditDetailsViewController") as? EditProfileViewController else { return }
        
        editDetailsVC.editProfileVM = editProfileVM
        editDetailsVC.dateOfBirth = user?.dateOfBirth
        
        navigationController?.pushViewController(editDetailsVC, animated: true)
    }
}
