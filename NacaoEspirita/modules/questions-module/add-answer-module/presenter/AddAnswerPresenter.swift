//
//  AddAnswerPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/25/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class AddAnswerPresenter: AddAnswerViewToPresenterProtocol {
    
    var view: AddAnswerPresenterToViewProtocol?
    var interactor: AddAnswerPresenterToInteractorProtocol?
    var router: AddAnswerPresenterToRouterProtocol?
    
    var navigationController: UINavigationController?
    
    func saveViewController(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func sendAnswerToPresenter(answer: String, id: String) {
        interactor?.validate(answer:answer, id: id)
    }
    
    func startFetchingAnswers(questionId: String) {
        interactor?.fetchAnswers(questionId: questionId)
    }
    
    func sendActionLike(_ like: Bool, questionId: String) {
        interactor?.checkStatusOfLike(like, questionId: questionId)
    }
    
    func sendActionLikeAnswer(_ like: Bool, questionId: String, answerId: String) {
        interactor?.checkStatusOfAnswerLike(like, questionId: questionId, answerId: answerId)
    }
}

extension AddAnswerPresenter: AddAnswerInteractorToPresenterProtocol {
    
    func saveAnswerDone() {
        view?.updateAnswers()
    }
    
    func answerFetchedSuccess(answerModelArray: [AnswerModel], statusUserLikeArray: [Bool]) {
        view?.showAnswers(answersArray: answerModelArray, statusUserLikeArray: statusUserLikeArray)
    }
    
    func sendError (message: String) {
        view?.showError(message: message)
    }
    
}
