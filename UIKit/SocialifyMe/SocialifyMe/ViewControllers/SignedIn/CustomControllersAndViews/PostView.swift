//
//  PostView.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 13/03/23.
//

import UIKit

class PostView: UIView {
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelTimeCreated: UILabel!
    @IBOutlet weak var imageViewPostPhoto: UIImageView!
    @IBOutlet weak var labelUserNameDescription: UILabel!
    @IBOutlet weak var labelPostDescription: UILabel!
    @IBOutlet weak var stackViewMain: UIStackView!
    @IBOutlet weak var stackViewDescription: UIStackView!
    @IBOutlet weak var buttonLikePost: UIButton!
    @IBOutlet weak var buttonCommentOnPost: UIButton!
    @IBOutlet weak var buttonSharePost: UIButton!
    @IBOutlet weak var buttonBookmarkPost: UIButton!
    
    typealias completion = (String, Bool) -> ()
    var postID: String!
    
    var likePostCompletion: completion?
    var isPostLiked: Bool = false
    
    var bookmarkPostCompletion: completion?
    var isPostBookmarked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("PostView", owner: self)![0] as! UIView
        stackViewMain.layer.cornerRadius = 10
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    @IBAction func buttonLikePostAction(_ sender: Any) {
        if let likePostCompletion = likePostCompletion {
            isPostLiked.toggle()
            self.buttonLikePost.setImage(UIImage(systemName: isPostLiked ? "heart.fill" : "heart"), for: .normal)
            
            likePostCompletion(postID, isPostLiked)
        }
    }
    
    @IBAction func buttonBookmarkPostAction(_ sender: Any) {
        if let bookmarkPostCompletion = bookmarkPostCompletion {
            isPostBookmarked.toggle()
            self.buttonBookmarkPost.setImage(UIImage(systemName: isPostBookmarked ? "bookmark.fill" : "bookmark"), for: .normal)
            
            bookmarkPostCompletion(postID, isPostBookmarked)
        }
    }
}
