//
//  LoginCreateViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase

class LoginCreateViewController: LoginBaseViewController {
    
    var presenter: LoginCreateViewToPresenterProtocol?
   
    @IBOutlet var background: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            self.createButton.roundCorners(.allCorners, radius: 16)
        }
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        
        guard let name = self.nameTextField.text, !name.isEmpty else {
            showError(message: AppAlert.ALERT_NAME_FIELD_EMPTY)
            return
        }
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            showError(message: AppAlert.ALERT_EMAIL_FIELD_EMPTY)
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            showError(message: AppAlert.ALERT_PASSWORD_FIELD_EMPTY)
            return
        }
        
        guard let confirmPassword = self.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showError(message: AppAlert.ALERT_CONFIRM_PASSWORD_FIELD_EMPTY)
            return
        }
        
        presenter?.sendToVerifyData(name: name, email: email, password: password, confirmPassword: confirmPassword)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundEffects(background: background)
        
        setTextFieldProperties()
    }
    
    fileprivate func setTextFieldProperties() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameTextField.tag = 0
        emailTextField.tag = 1
        passwordTextField.tag = 2
        confirmPasswordTextField.tag = 3
        
        passwordTextField.isSecureTextEntry.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
}

//MARK: Interaction between Presenter and View
extension LoginCreateViewController: LoginCreatePresenterToViewProtocol {
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
