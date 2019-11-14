//
//  LoginBaseViewController.swift
//  Wellbe
//
//  Created by Felippe Matos Francoski on 12/17/18.
//  Copyright © 2018 Guilhermino Afonso. All rights reserved.
//

import UIKit
import Firebase

class LoginBaseViewController: UIViewController, UITextFieldDelegate {
    
    var activeField : UITextField?
    var keyboardHeight : CGFloat = 0
    var viewHeight: CGFloat = 0
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        viewHeight = self.view.frame.size.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func setBackgroundEffects(background: UIView) {
        let snow = ParticleBackgroundView()
        snow.particleImage = UIImage(named: "snow-particle")
        snow.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(snow)
        
        let parallax = ParallaxBackgroundView()
        let group = parallax.addParallaxToView(vw: background)
        background.addMotionEffect(group)
        
        NSLayoutConstraint.activate([
            snow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -30),
            snow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30),
            snow.topAnchor.constraint(equalTo: view.topAnchor, constant: -30),
            snow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            ])
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        let backItem = UIBarButtonItem()
        backItem.title = AppText.NAVIGATION_BACK
        navigationItem.backBarButtonItem = backItem
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.checkIfNecessaryDownTheView()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
        if !self.checkIfNecessaryUpTheView() {
            self.checkIfNecessaryDownTheView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func checkIfNecessaryUpTheView() -> Bool {
        guard let textFieldOrigin = self.activeField?.frame.origin.y else {return false}
        guard let textFieldHeight = self.activeField?.frame.size.height else {return false}

        if (textFieldOrigin + textFieldHeight) > (viewHeight - keyboardHeight){
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.7) {
                    self.view.frame.origin.y -= (self.keyboardHeight - 120)
                }
                return true
            }
        }
        return false
    }
    
    func checkIfNecessaryDownTheView() {
        if self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.7) {
                self.view.frame.origin.y = 0
            }
        }
    }
}

public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//TODO: Ajeitar essa classe
extension LoginBaseViewController {
    
    func showAlert(titleAlert: String, message: String? = "", titleButton: String, dismissScreen: Bool? = false) -> UIAlertController {
        let alertController = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        
//        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = theme.backgroundColor()
//        alertController.view.tintColor = theme.textColor()
//        alertController.addImage(theme.image()!)
        
        let action1 = UIAlertAction(title: titleButton, style: .default) { (action:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
            if dismissScreen! {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(action1)
        return alertController
    }
}
