//
//  HomeScheduleRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 14/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class HomeScheduleRouter: HomeSchedulePresenterToRouterProtocol {
    
    static func createModule() -> HomeScheduleViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "HomeScheduleViewController") as! HomeScheduleViewController
        
        let presenter: HomeScheduleViewToPresenterProtocol & HomeScheduleInteractorToPresenterProtocol = HomeSchedulePresenter()
        let interactor: HomeSchedulePresenterToInteractorProtocol = HomeScheduleInteractor()
        let router: HomeSchedulePresenterToRouterProtocol = HomeScheduleRouter()
        
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
