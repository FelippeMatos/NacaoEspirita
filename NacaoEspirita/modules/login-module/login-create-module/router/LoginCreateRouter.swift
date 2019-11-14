//
//  LoginCreateRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class LoginCreateRouter: LoginCreatePresenterToRouterProtocol {
    
    static func createModule() -> LoginCreateViewController {
        
        let view = loginStoryboard.instantiateViewController(withIdentifier: "LoginCreate") as! LoginCreateViewController
        let presenter: LoginCreateViewToPresenterProtocol & LoginCreateInteractorToPresenterProtocol = LoginCreatePresenter()
        let interactor: LoginCreatePresenterToInteractorProtocol = LoginCreateInteractor()
        let router: LoginCreatePresenterToRouterProtocol = LoginCreateRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var loginStoryboard: UIStoryboard {
        return UIStoryboard(name:"Login", bundle: Bundle.main)
    }
    
    func pushToHomeScreen() {
        //SET NEW NAVIGATION TO HOME
        let homeModule = HomeRouter.createModuleTabBar()
        
        //Initiating instance of ui-navigation-controller with view-controller
        let navigationController = UINavigationController()
        navigationController.viewControllers = [homeModule]
        
        //Setting up the root view-controller as ui-navigation-controller
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = navigationController
        appDelegate.window!.makeKeyAndVisible()
    }
    
}
