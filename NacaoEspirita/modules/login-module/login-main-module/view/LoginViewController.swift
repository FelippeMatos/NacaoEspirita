//
//  LoginViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/15/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: LoginBaseViewController {
    
    var presenter: LoginViewToPresenterProtocol?
    
    @IBOutlet var background: UIView!
    
    @IBOutlet weak var facebookButton: UIButton! {
        didSet {
            self.facebookButton.roundCorners(.allCorners, radius: 16)
        }
    }
    
    @IBOutlet weak var accessButton: UIButton! {
        didSet {
            self.accessButton.roundCorners(.allCorners, radius: 16)
        }
    }
    
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            self.createButton.roundCorners(.allCorners, radius: 16)
        }
    }
    
    @IBAction func FacebookButtonAction(_ sender: Any) {
        presenter?.callFacebookLogin(view: self)
    }
    
    @IBAction func AccessAcountButtonAction(_ sender: Any) {
        guard let view = navigationController, navigationController != nil else {
            return
        }
        
        presenter?.showLoginAccessController(navigationController: view)
    }
    
    @IBAction func CreateAccountButtonAction(_ sender: Any) {
        guard let view = navigationController, navigationController != nil else {
            return
        }
        
        presenter?.showLoginCreateController(navigationController: view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundEffects(background: background)
        
    }
    
}

//MARK: Interaction between Presenter and View
extension LoginViewController: LoginPresenterToViewProtocol {
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
