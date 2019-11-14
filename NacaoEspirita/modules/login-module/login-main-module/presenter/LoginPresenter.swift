//
//  LoginPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/15/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class LoginPresenter: LoginViewToPresenterProtocol {
    
    var view: LoginPresenterToViewProtocol?
    var interactor: LoginPresenterToInteractorProtocol?
    var router: LoginPresenterToRouterProtocol?
    
    func callFacebookLogin(view: UIViewController) {
        
        interactor?.makeFacebookLogin(view: view)
    }
    
    func showLoginAccessController(navigationController: UINavigationController) {
        router?.pushToLoginAccessScreen(navigationController: navigationController)
    }
    
    func showLoginCreateController(navigationController: UINavigationController) {
        router?.pushToLoginCreateScreen(navigationController: navigationController)
    }
}

extension LoginPresenter: LoginInteractorToPresenterProtocol {
    
    func successFacebookLogin() {
        router?.pushToHomeScreen()
    }
    
    func sendError (message: String) {
        view?.showError(message: message)
    }
    
}
