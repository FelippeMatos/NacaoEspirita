//
//  LoginProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/15/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol LoginViewToPresenterProtocol: class {

    var view: LoginPresenterToViewProtocol? {get set}
    var interactor: LoginPresenterToInteractorProtocol? {get set}
    var router: LoginPresenterToRouterProtocol? {get set}
    
    func callFacebookLogin(view: UIViewController)
    func showLoginAccessController(navigationController: UINavigationController)
    func showLoginCreateController(navigationController: UINavigationController)
}

// Presenter -> View
protocol LoginPresenterToViewProtocol: class {
    func showError(message: String)
}

// Presenter -> Router
protocol LoginPresenterToRouterProtocol: class {
    func pushToLoginAccessScreen(navigationController: UINavigationController)
    func pushToLoginCreateScreen(navigationController: UINavigationController)
    func pushToHomeScreen()
}

// Presenter -> Interactor
protocol LoginPresenterToInteractorProtocol: class {
    var presenter: LoginInteractorToPresenterProtocol? {get set}
    
    func makeFacebookLogin(view: UIViewController)
}

// Interactor -> Presenter
protocol LoginInteractorToPresenterProtocol: class {
    func sendError(message: String)
    func successFacebookLogin()
}
