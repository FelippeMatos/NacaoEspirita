//
//  HomeProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/18/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol HomeViewToPresenterProtocol: class {
    
    var view: HomePresenterToViewProtocol? {get set}
    var interactor: HomePresenterToInteractorProtocol? {get set}
    var router: HomePresenterToRouterProtocol? {get set}
    
}

// Presenter -> View
protocol HomePresenterToViewProtocol: class {

}

// Presenter -> Router
protocol HomePresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol HomePresenterToInteractorProtocol: class {
    var presenter: HomeInteractorToPresenterProtocol? {get set}
    
}

// Interactor -> Presenter
protocol HomeInteractorToPresenterProtocol: class {
    
}
