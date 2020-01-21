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
    
    func sendLikeAction(_ like: Bool, questionId: String) {
        interactor?.checkStatusOfLike(like, questionId: questionId)
    }
    
    func sendPinAction(_ questionId: String, toSave: Bool) {
        interactor?.updatePinQuestion(questionId, toSave: toSave)
    }
}

extension QuestionsPresenter: QuestionsInteractorToPresenterProtocol {
    
    func questionsFetchedSuccess(questionsModelArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel], pinQuestionsArray: [Bool]) {
        view?.showQuestions(questionsArray: questionsModelArray, statusUserLikeArray: statusUserLikeArray, topAnswerArray: topAnswerArray, pinQuestionsArray: pinQuestionsArray)
    }
    
    func questionsFetchFailed() {
        view?.showError()
    }
    
    func pinQuestionFailed() {
        view?.showError()
    }
    
    func pinQuestionSuccess() {
        view?.showSuccess()
    }
    
}
