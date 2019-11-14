//
//  LoginAccessInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class LoginAccessInteractor: LoginAccessPresenterToInteractorProtocol {
    var presenter: LoginAccessInteractorToPresenterProtocol?
    
    func accessAccount(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                self!.presenter?.failedAccessAccount(error: AppAlert.ALERT_FAILED_ACCESS)
                return
            }
            self!.presenter?.successAccessAccount()
        }
    }
}
