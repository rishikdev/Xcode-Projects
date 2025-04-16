//
//  UIImageViewExtension.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // MARK: - Round Image
    /// Makes image round.
    /// 
    func roundImage() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    
    // MARK: - Load
    /// Loads images using the provided URL.
    ///
    /// - Parameter urlString: The `URL` of the image to be loaded.
    ///
    /// - Note: The `URL` is of type `String` and not `URL`.
    ///
    func load(_ urlString: String) {
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {[weak self] in
            guard let data = try? Data(contentsOf: url) else { return }

            guard let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.image = image
                imageCache.setObject(image, forKey: urlString as NSString)
            }
        }
    }
}
