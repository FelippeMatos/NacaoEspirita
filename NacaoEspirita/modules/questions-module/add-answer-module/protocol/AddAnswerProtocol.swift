//
//  AddAnswerProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/25/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol AddAnswerViewToPresenterProtocol: class {
    
    var view: AddAnswerPresenterToViewProtocol? {get set}
    var interactor: AddAnswerPresenterToInteractorProtocol? {get set}
    var router: AddAnswerPresenterToRouterProtocol? {get set}
    
    func sendAnswerToPresenter(answer: String, id: String)
    func saveViewController(navigationController: UINavigationController)
    func startFetchingAnswers(questionId: String)
    func sendActionLike(_ like: Bool, questionId: String)
    func sendActionLikeAnswer(_ like: Bool, questionId: String, answerId: String)
    func sendPinAction(_ questionId: String, toSave: Bool)
}

// Presenter -> View
protocol AddAnswerPresenterToViewProtocol: class {
    func showAnswers(answersArray: [AnswerModel], statusUserLikeArray: [Bool], questionPin: Bool)
    func showError(message: String)
    func showSuccess()
    func updateAnswers()
}

// Presenter -> Router
protocol AddAnswerPresenterToRouterProtocol: class {
    func dismissScreen(navigationController: UINavigationController)
}

// Presenter -> Interactor
protocol AddAnswerPresenterToInteractorProtocol: class {
    var presenter: AddAnswerInteractorToPresenterProtocol? {get set}
    
    func validate(answer: String, id: String)
    func fetchAnswers(questionId: String)
    func checkStatusOfLike(_ like: Bool, questionId: String)
    func checkStatusOfAnswerLike(_ like: Bool, questionId: String, answerId: String)
    func updatePinQuestion(_ questionId: String, toSave: Bool)
}

// Interactor -> Presenter
protocol AddAnswerInteractorToPresenterProtocol: class {
    func sendError(message: String)
    func saveAnswerDone()
    func pinQuestionSuccess()
    func pinQuestionFailed()
    
    func answerFetchedSuccess(answerModelArray: [AnswerModel], statusUserLikeArray: [Bool], questionPin: Bool)
}
