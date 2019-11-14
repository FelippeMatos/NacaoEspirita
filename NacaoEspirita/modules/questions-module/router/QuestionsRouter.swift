//
//  QuestionsRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class QuestionsRouter: QuestionsPresenterToRouterProtocol {
    
    static func createModule() -> QuestionsViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "Questions") as! QuestionsViewController
        let presenter: QuestionsViewToPresenterProtocol & QuestionsInteractorToPresenterProtocol = QuestionsPresenter()
        let interactor: QuestionsPresenterToInteractorProtocol = QuestionsInteractor()
        let router: QuestionsPresenterToRouterProtocol = QuestionsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }

    static var homeStoryboard: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
    func pushToAddQuestionScreen(navigationController: UINavigationController) {
        let addQuestionModule = AddQuestionRouter.createModule()
        navigationController.pushViewController(addQuestionModule, animated: true)
    }
    
    func pushToAddAnswerScreen(question: QuestionModel, navigationController: UINavigationController, focus: Bool, likeStatus: Int) {
        let addAnswerModule = AddAnswerRouter.createModule(question: question, focus: focus, likeStatus: likeStatus)
        navigationController.pushViewController(addAnswerModule, animated: true)
    }
    
}
