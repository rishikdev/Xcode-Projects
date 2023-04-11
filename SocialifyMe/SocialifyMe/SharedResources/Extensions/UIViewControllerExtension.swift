//
//  ViewControllerExtension.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 09/03/23.
//

import UIKit

extension UIViewController {
    func switchRootViewController(to viewController: UIViewController) {
        if let sceneDalagate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDalagate.window {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
