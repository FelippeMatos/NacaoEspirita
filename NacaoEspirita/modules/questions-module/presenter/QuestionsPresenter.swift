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
    
    var totalQuestions = 0

    func showAddQuestionController(navigationController: UINavigationController) {
        router?.pushToAddQuestionScreen(navigationController: navigationController)
    }
    
    func startFetchingNumberOfQuestionsInFB() {
        interactor?.fetchNumberOfQuestionsInFB()
    }
    
    func getNumberOfQuestions() -> Int {
        return totalQuestions
    }
    
    func startFetchingQuestions(_ all: Bool) {
        interactor?.fetchQuestions(all)
    }
    
    func startFetchingSavedQuestions() {
        interactor?.fetchSavedQuestions()
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
    
    func questionsFetchedSuccess(questionsModelArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel], pinQuestionsArray: [Bool], indexPathsToReload: [IndexPath]?) {
        
        self.totalQuestions = questionsModelArray.count
        view?.showQuestions(questionsArray: questionsModelArray, statusUserLikeArray: statusUserLikeArray, topAnswerArray: topAnswerArray, pinQuestionsArray: pinQuestionsArray, newIndexPathsToReload: indexPathsToReload)
    }
    
    func questionsFetchFailed(message: String) {
        view?.showError(message: message)
    }
    
    func pinDeleteQuestionSuccess(message: String) {
        view?.showSuccess()
    }
    
    func pinSaveQuestionSuccess() {
        view?.showSuccess()
    }
    
}
