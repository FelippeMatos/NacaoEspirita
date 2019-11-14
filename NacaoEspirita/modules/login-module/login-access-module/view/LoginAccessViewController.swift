//
//  LoginAccessViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase

class LoginAccessViewController: LoginBaseViewController  {
    
    var presenter: LoginAccessViewToPresenterProtocol?
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var accessButton: UIButton! {
        didSet {
            self.accessButton.roundCorners(.allCorners, radius: 16)
        }
    }
    @IBAction func accessAccountAction(_ sender: Any) {
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            showError(message: AppAlert.ALERT_EMAIL_FIELD_EMPTY)
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            showError(message: AppAlert.ALERT_PASSWORD_FIELD_EMPTY)
            return
        }
    
        presenter?.verifyAccessAccount(email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundEffects(background: background)
        
        setTextFieldProperties()
    }
    
    fileprivate func setTextFieldProperties() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        passwordTextField.isSecureTextEntry.toggle()
    }
}

//MARK: Interaction between Presenter and View
extension LoginAccessViewController: LoginAccessPresenterToViewProtocol {
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
