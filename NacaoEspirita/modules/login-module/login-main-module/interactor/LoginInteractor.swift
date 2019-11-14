//
//  LoginInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/15/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class LoginInteractor: LoginPresenterToInteractorProtocol {
    var presenter: LoginInteractorToPresenterProtocol?
    
    func makeFacebookLogin(view: UIViewController) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: view) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    self.presenter?.sendError(message: error.localizedDescription)
                    return
                }
                self.presenter?.successFacebookLogin()
            })
            
        }
    }
}
