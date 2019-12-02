//
//  MidiaVideoDisplayRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaVideoDisplayRouter: MidiaVideoDisplayPresenterToRouterProtocol {
    
    static func createModule(url: String) -> MidiaVideoDisplayViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "MidiaVideoDisplay") as! MidiaVideoDisplayViewController
        let presenter: MidiaVideoDisplayViewToPresenterProtocol = MidiaVideoDisplayPresenter()
        let router: MidiaVideoDisplayPresenterToRouterProtocol = MidiaVideoDisplayRouter()
        
        view.presenter = presenter
        view.url = url
        presenter.view = view
        presenter.router = router
        
        return view
    }
    
    static var homeStoryboard: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: Bundle.main)
    }
    
}
