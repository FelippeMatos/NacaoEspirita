//
//  LoginCreateProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol LoginCreateViewToPresenterProtocol: class {
    var view: LoginCreatePresenterToViewProtocol? {get set}
    var interactor: LoginCreatePresenterToInteractorProtocol? {get set}
    var router: LoginCreatePresenterToRouterProtocol? {get set}
    
    func sendToVerifyData(name: String, email: String, password: String, confirmPassword: String)
}

// Presenter -> View
protocol LoginCreatePresenterToViewProtocol: class {
    func showError(message: String)
}

// Presenter -> Router
protocol LoginCreatePresenterToRouterProtocol: class {
    func pushToHomeScreen()
}

// Presenter -> Interactor
protocol LoginCreatePresenterToInteractorProtocol: class {
    var presenter: LoginCreateInteractorToPresenterProtocol? {get set}
    
    func verifyData(name: String, email: String, password: String, confirmPassword: String)
}

// Interactor -> Presenter
protocol LoginCreateInteractorToPresenterProtocol: class {
    func sendError(message: String)
    func successfullyCreated()
}
