//
//  MidiaBookDisplayProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/8/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol MidiaBookDisplayViewToPresenterProtocol: class {
    
    var view: MidiaBookDisplayPresenterToViewProtocol? {get set}
    var interactor: MidiaBookDisplayPresenterToInteractorProtocol? {get set}
    var router: MidiaBookDisplayPresenterToRouterProtocol? {get set}
    
}

// Presenter -> View
protocol MidiaBookDisplayPresenterToViewProtocol: class {
    
}

// Presenter -> Router
protocol MidiaBookDisplayPresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol MidiaBookDisplayPresenterToInteractorProtocol: class {
    var presenter: MidiaBookDisplayInteractorToPresenterProtocol? {get set}
    
}

// Interactor -> Presenter
protocol MidiaBookDisplayInteractorToPresenterProtocol: class {
    
}
