//
//  MidiaRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaRouter: MidiaPresenterToRouterProtocol {
    
    static func createModule() -> MidiaViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "Midia") as! MidiaViewController
        let presenter: MidiaViewToPresenterProtocol & MidiaInteractorToPresenterProtocol = MidiaPresenter()
        let interactor: MidiaPresenterToInteractorProtocol = MidiaInteractor()
        let router: MidiaPresenterToRouterProtocol = MidiaRouter()
        
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
    
}

