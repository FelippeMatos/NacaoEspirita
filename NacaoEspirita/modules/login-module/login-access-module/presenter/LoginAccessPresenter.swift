//
//  LoginAccessPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class LoginAccessPresenter: LoginAccessViewToPresenterProtocol {
    
    var view: LoginAccessPresenterToViewProtocol?
    var interactor: LoginAccessPresenterToInteractorProtocol?
    var router: LoginAccessPresenterToRouterProtocol?
    
    var navigationController: UINavigationController?
    
    func verifyAccessAccount(email: String, password: String) {
        interactor?.accessAccount(email: email, password: password)
    }
    
}

extension LoginAccessPresenter: LoginAccessInteractorToPresenterProtocol {
    
    func successAccessAccount() {
        router?.pushToHomeScreen()
    }
    
    func failedAccessAccount(error: String) {
        view?.showError(message: error)
    }
}
