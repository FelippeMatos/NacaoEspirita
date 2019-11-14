//
//  LoginCreateInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class LoginCreateInteractor: LoginCreatePresenterToInteractorProtocol {
    var presenter: LoginCreateInteractorToPresenterProtocol?
    
    func verifyData(name: String, email: String, password: String, confirmPassword: String) {
        if password == confirmPassword {
            if password.count >= 6 {
                createAccount(email: email, password: password, displayName: name)
            } else {
                presenter?.sendError(message: AppAlert.ALERT_PASSWORD_LESS_6_CHARACTERS)
            }
        } else {
            presenter?.sendError(message: AppAlert.ALERT_PASSWORD_DIFFERENT)
        }
    }
    
    func createAccount(email: String, password: String, displayName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("$$$$$$$ ERRO: \(error)")
                        } else {
                            self.presenter?.successfullyCreated()
                        }
                    }
                }
            }
        }
    }
}
