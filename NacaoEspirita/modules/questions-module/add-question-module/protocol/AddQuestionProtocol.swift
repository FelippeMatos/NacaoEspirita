//
//  AddQuestionProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/24/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol AddQuestionViewToPresenterProtocol: class {
    
    var view: AddQuestionPresenterToViewProtocol? {get set}
    var interactor: AddQuestionPresenterToInteractorProtocol? {get set}
    var router: AddQuestionPresenterToRouterProtocol? {get set}
    
    func sendQuestionToPresenter(question: String)
    func saveViewController(navigationController: UINavigationController)

}

// Presenter -> View
protocol AddQuestionPresenterToViewProtocol: class {
    func showError(message: String)
}

// Presenter -> Router
protocol AddQuestionPresenterToRouterProtocol: class {
    func dismissScreen(navigationController: UINavigationController)
}

// Presenter -> Interactor
protocol AddQuestionPresenterToInteractorProtocol: class {
    var presenter: AddQuestionInteractorToPresenterProtocol? {get set}
    
    func validate(question: String)
}

// Interactor -> Presenter
protocol AddQuestionInteractorToPresenterProtocol: class {
    func saveQuestionDone()
    func sendError(message: String)
}
