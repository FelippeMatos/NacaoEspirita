//
//  AddAnswerRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/25/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class AddAnswerRouter: AddAnswerPresenterToRouterProtocol {
    
    static func createModule(question: QuestionModel, focus: Bool, likeStatus: Int) -> AddAnswerViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "AddAnswer") as! AddAnswerViewController
        let presenter: AddAnswerViewToPresenterProtocol & AddAnswerInteractorToPresenterProtocol = AddAnswerPresenter()
        let interactor: AddAnswerPresenterToInteractorProtocol = AddAnswerInteractor()
        let router: AddAnswerPresenterToRouterProtocol = AddAnswerRouter()
        
        view.presenter = presenter
        view.question = question
        view.focus = focus
        view.likeStatus = likeStatus
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var homeStoryboard: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
    func dismissScreen(navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
}
