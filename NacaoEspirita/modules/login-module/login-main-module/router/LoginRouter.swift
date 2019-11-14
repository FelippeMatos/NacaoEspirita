//
//  LoginRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/15/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter: LoginPresenterToRouterProtocol {
    
    static func createModule() -> LoginViewController {
        
        let view =  loginStoryboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        let presenter: LoginViewToPresenterProtocol & LoginInteractorToPresenterProtocol = LoginPresenter()
        let interactor: LoginPresenterToInteractorProtocol = LoginInteractor()
        let router: LoginPresenterToRouterProtocol = LoginRouter()

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
    
    func pushToLoginAccessScreen(navigationController: UINavigationController) {
        let accessModule = LoginAccessRouter.createModule()
        navigationController.pushViewController(accessModule, animated: true)
    }
    
    func pushToLoginCreateScreen(navigationController: UINavigationController) {
        let createModule = LoginCreateRouter.createModule()
        navigationController.pushViewController(createModule, animated: true)
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
