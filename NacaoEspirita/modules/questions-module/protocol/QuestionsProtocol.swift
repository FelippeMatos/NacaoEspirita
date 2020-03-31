//
//  QuestionsProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol QuestionsViewToPresenterProtocol: class {
    
    var view: QuestionsPresenterToViewProtocol? {get set}
    var interactor: QuestionsPresenterToInteractorProtocol? {get set}
    var router: QuestionsPresenterToRouterProtocol? {get set}
    
    func showAddQuestionController(navigationController: UINavigationController)
    func startFetchingQuestions(_ all: Bool)
    func getNumberOfQuestions() -> Int
    func startFetchingNumberOfQuestionsInFB()
    func startFetchingSavedQuestions()
    func goToAddAnswerScreen(question: QuestionModel, navigationController: UINavigationController, focus: Bool, likeStatus: Int)
    func sendLikeAction(_ like: Bool, questionId: String)
    func sendPinAction(_ questionId: String, toSave: Bool)
}

// Presenter -> View
protocol QuestionsPresenterToViewProtocol: class {
    func showQuestions(questionsArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel], pinQuestionsArray: [Bool], newIndexPathsToReload: [IndexPath]?)
    func showError(message: String)
    func showSuccess()
    func updateQuestionLike(likeOrDislike: Int, indexQuestion: Int, newValueForStatusLike: Int)
}

// Presenter -> Router
protocol QuestionsPresenterToRouterProtocol: class {
    func pushToAddQuestionScreen(navigationController: UINavigationController)
    func pushToAddAnswerScreen(question: QuestionModel, navigationController: UINavigationController, focus: Bool, likeStatus: Int)
}

// Presenter -> Interactor
protocol QuestionsPresenterToInteractorProtocol: class {
    var presenter: QuestionsInteractorToPresenterProtocol? {get set}
    func fetchQuestions(_ all: Bool)
    func fetchSavedQuestions()
    func fetchNumberOfQuestionsInFB()
    func checkStatusOfLike(_ like: Bool, questionId: String)
    func updatePinQuestion(_ questionId: String, toSave: Bool)
}

// Interactor -> Presenter
protocol QuestionsInteractorToPresenterProtocol: class {
    func questionsFetchedSuccess(questionsModelArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel], pinQuestionsArray: [Bool], indexPathsToReload: [IndexPath]?)
    func questionsFetchFailed(message: String)
    func pinSaveQuestionSuccess()
    func pinDeleteQuestionSuccess(message: String)
}
