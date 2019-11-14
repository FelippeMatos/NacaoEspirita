//
//  QuestionsPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class QuestionsPresenter: QuestionsViewToPresenterProtocol {
    
    var view: QuestionsPresenterToViewProtocol?
    var interactor: QuestionsPresenterToInteractorProtocol?
    var router: QuestionsPresenterToRouterProtocol?

    func showAddQuestionController(navigationController: UINavigationController) {
        router?.pushToAddQuestionScreen(navigationController: navigationController)
    }
    
    func startFetchingQuestions() {
        interactor?.fetchQuestions()
    }
    
    func goToAddAnswerScreen(question: QuestionModel, navigationController: UINavigationController, focus: Bool, likeStatus: Int) {
        router?.pushToAddAnswerScreen(question: question, navigationController: navigationController, focus: focus, likeStatus: likeStatus)
    }
    
    func sendActionLike(_ like: Bool, questionId: String) {
        interactor?.checkStatusOfLike(like, questionId: questionId)
    }
}

extension QuestionsPresenter: QuestionsInteractorToPresenterProtocol {
    
    func questionsFetchedSuccess(questionsModelArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel]) {
        view?.showQuestions(questionsArray: questionsModelArray, statusUserLikeArray: statusUserLikeArray, topAnswerArray: topAnswerArray)
    }
    
    func questionsFetchFailed() {
        view?.showError()
    }
    
}
