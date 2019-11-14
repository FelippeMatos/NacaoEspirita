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
    func startFetchingQuestions()
    func goToAddAnswerScreen(question: QuestionModel, navigationController: UINavigationController, focus: Bool, likeStatus: Int)
    func sendActionLike(_ like: Bool, questionId: String)
}

// Presenter -> View
protocol QuestionsPresenterToViewProtocol: class {
    func showQuestions(questionsArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel])
    func showError()
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
    func fetchQuestions()
    func checkStatusOfLike(_ like: Bool, questionId: String)
}

// Interactor -> Presenter
protocol QuestionsInteractorToPresenterProtocol: class {
    func questionsFetchedSuccess(questionsModelArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel])
    func questionsFetchFailed()
}
