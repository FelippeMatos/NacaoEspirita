//
//  AddQuestionRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/24/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class AddQuestionRouter: AddQuestionPresenterToRouterProtocol {
    
    static func createModule() -> AddQuestionViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "AddQuestion") as! AddQuestionViewController
        let presenter: AddQuestionViewToPresenterProtocol & AddQuestionInteractorToPresenterProtocol = AddQuestionPresenter()
        let interactor: AddQuestionPresenterToInteractorProtocol = AddQuestionInteractor()
        let router: AddQuestionPresenterToRouterProtocol = AddQuestionRouter()
        
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
    
    func dismissScreen(navigationController: UINavigationController) {
        navigationController.popViewController(animated: true)
    }
}
