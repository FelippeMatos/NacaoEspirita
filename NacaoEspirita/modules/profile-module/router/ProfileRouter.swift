//
//  ProfileRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class ProfileRouter: ProfilePresenterToRouterProtocol {
    
    static func createModule() -> ProfileViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        let presenter: ProfileViewToPresenterProtocol & ProfileInteractorToPresenterProtocol = ProfilePresenter()
        let interactor: ProfilePresenterToInteractorProtocol = ProfileInteractor()
        let router: ProfilePresenterToRouterProtocol = ProfileRouter()
        
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
