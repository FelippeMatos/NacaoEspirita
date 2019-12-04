//
//  HomeRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/18/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class HomeRouter: HomePresenterToRouterProtocol {
    
    static func createModule() -> HomeViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        let presenter: HomeViewToPresenterProtocol & HomeInteractorToPresenterProtocol = HomePresenter()
        let interactor: HomePresenterToInteractorProtocol = HomeInteractor()
        let router: HomePresenterToRouterProtocol = HomeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static func createModuleTabBar() -> UIViewController {
        let view = homeStoryboard.instantiateViewController(withIdentifier: "TabBar") as! TabBarController
        return view
    }
    
    static var homeStoryboard: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
}
