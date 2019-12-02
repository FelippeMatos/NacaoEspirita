//
//  MidiaAllVideosRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaAllVideosRouter: MidiaAllVideosPresenterToRouterProtocol {
    
    static func createModule() -> MidiaAllVideosViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "MidiaAllVideos") as! MidiaAllVideosViewController
        let presenter: MidiaAllVideosViewToPresenterProtocol & MidiaAllVideosInteractorToPresenterProtocol = MidiaAllVideosPresenter()
        let interactor: MidiaAllVideosPresenterToInteractorProtocol = MidiaAllVideosInteractor()
        let router: MidiaAllVideosPresenterToRouterProtocol = MidiaAllVideosRouter()
        
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
    
    func pushToVideoDisplayScreen(navigationController: UINavigationController, id: String) {
        let url = "https://www.youtube.com/watch?v=\(id)"
        let midiaVideoDisplayModule = MidiaVideoDisplayRouter.createModule(url: url)
        navigationController.pushViewController(midiaVideoDisplayModule, animated: true)
    }
}
