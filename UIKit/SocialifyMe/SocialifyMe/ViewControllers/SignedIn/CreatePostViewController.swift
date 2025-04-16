//
//  CreatePostViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 14/03/23.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelCreatePost: UILabel!
    @IBOutlet weak var stackViewMain: UIStackView!
    @IBOutlet weak var textViewPostDescription: UITextView!
    @IBOutlet weak var buttonSelectPhoto: UIButton!
    @IBOutlet weak var buttonPost: UIButton!
    @IBOutlet weak var imageViewSelectedPhoto: UIImageView!
    
    var createPostVM: CreatePostViewModel!
    var postPhotoURLPath: URL?
    var delegate: CreatePostVCProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        initialConfiguration()
    }
    
    @IBAction func buttonCancelAction(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func buttonPostAction(_ sender: Any) {
        uploadPost()
    }
    
    @IBAction func buttonSelectPhotoAction(_ sender: Any) {
        selectPhotoHandler()
    }
}
