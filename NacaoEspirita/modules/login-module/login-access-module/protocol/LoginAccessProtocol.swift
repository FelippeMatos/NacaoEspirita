//
//  LoginAccessProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol LoginAccessViewToPresenterProtocol: class {
    var view: LoginAccessPresenterToViewProtocol? {get set}
    var interactor: LoginAccessPresenterToInteractorProtocol? {get set}
    var router: LoginAccessPresenterToRouterProtocol? {get set}
    
    func verifyAccessAccount(email: String, password: String)
}

// Presenter -> View
protocol LoginAccessPresenterToViewProtocol: class {
    func showError(message: String)
}

// Presenter -> Router
protocol LoginAccessPresenterToRouterProtocol: class {
    func pushToHomeScreen()
}

// Presenter -> Interactor
protocol LoginAccessPresenterToInteractorProtocol: class {
    var presenter: LoginAccessInteractorToPresenterProtocol? {get set}
    
    func accessAccount(email: String, password: String)
}

// Interactor -> Presenter
protocol LoginAccessInteractorToPresenterProtocol: class {
    
    func successAccessAccount()
    func failedAccessAccount(error: String)
}
