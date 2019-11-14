//
//  LoginCreatePresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class LoginCreatePresenter: LoginCreateViewToPresenterProtocol {
    
    var view: LoginCreatePresenterToViewProtocol?
    var interactor: LoginCreatePresenterToInteractorProtocol?
    var router: LoginCreatePresenterToRouterProtocol?
    
    func sendToVerifyData(name: String, email: String, password: String, confirmPassword: String) {
        interactor?.verifyData(name: name, email: email, password: password, confirmPassword: confirmPassword)
    }
    
}

extension LoginCreatePresenter: LoginCreateInteractorToPresenterProtocol {
    
    func sendError (message: String) {
        view?.showError(message: message)
    }
    
    func successfullyCreated() {
        router?.pushToHomeScreen()
    }
}
