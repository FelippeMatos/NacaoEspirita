//
//  AddQuestionPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/24/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class AddQuestionPresenter: AddQuestionViewToPresenterProtocol {
    
    var view: AddQuestionPresenterToViewProtocol?
    var interactor: AddQuestionPresenterToInteractorProtocol?
    var router: AddQuestionPresenterToRouterProtocol?
    
    var navigationController: UINavigationController?
    
    func sendQuestionToPresenter(question: String) {
        interactor?.validate(question: question)
    }
    
    func saveViewController(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AddQuestionPresenter: AddQuestionInteractorToPresenterProtocol {
    
    func saveQuestionDone() {
        router?.dismissScreen(navigationController: navigationController!)
    }
    
    func sendError (message: String) {
        view?.showError(message: message)
    }
    
}

