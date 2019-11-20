//
//  MidiaAllBooksRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/20/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaAllBooksRouter: MidiaAllBooksPresenterToRouterProtocol {
    
    static func createModule() -> MidiaAllBooksViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "MidiaAllBooks") as! MidiaAllBooksViewController
        let presenter: MidiaAllBooksViewToPresenterProtocol & MidiaAllBooksInteractorToPresenterProtocol = MidiaAllBooksPresenter()
        let interactor: MidiaAllBooksPresenterToInteractorProtocol = MidiaAllBooksInteractor()
        let router: MidiaAllBooksPresenterToRouterProtocol = MidiaAllBooksRouter()
        
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
