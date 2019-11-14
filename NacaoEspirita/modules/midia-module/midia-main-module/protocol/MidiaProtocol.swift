//
//  MidiaProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol MidiaViewToPresenterProtocol: class {
    
    var view: MidiaPresenterToViewProtocol? {get set}
    var interactor: MidiaPresenterToInteractorProtocol? {get set}
    var router: MidiaPresenterToRouterProtocol? {get set}
    
}

// Presenter -> View
protocol MidiaPresenterToViewProtocol: class {

}

// Presenter -> Router
protocol MidiaPresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol MidiaPresenterToInteractorProtocol: class {
    var presenter: MidiaInteractorToPresenterProtocol? {get set}
    
}

// Interactor -> Presenter
protocol MidiaInteractorToPresenterProtocol: class {

}

