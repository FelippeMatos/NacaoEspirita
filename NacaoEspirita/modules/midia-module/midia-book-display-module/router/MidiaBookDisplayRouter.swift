//
//  MidiaBookDisplayRouter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/8/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class MidiaBookDisplayRouter: MidiaBookDisplayPresenterToRouterProtocol {
    
    static func createModule(pdfUrl: URL) -> MidiaBookDisplayViewController {
        
        let view = homeStoryboard.instantiateViewController(withIdentifier: "MidiaBookDisplay") as! MidiaBookDisplayViewController
        let presenter: MidiaBookDisplayViewToPresenterProtocol & MidiaBookDisplayInteractorToPresenterProtocol = MidiaBookDisplayPresenter()
        let interactor: MidiaBookDisplayPresenterToInteractorProtocol = MidiaBookDisplayInteractor()
        let router: MidiaBookDisplayPresenterToRouterProtocol = MidiaBookDisplayRouter()
        
        view.presenter = presenter
        view.pdfUrl = pdfUrl
        view.document = PDFDocument(url: pdfUrl)
        view.outline = view.document.outlineRoot
        view.pdfView.document = view.document
        
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
