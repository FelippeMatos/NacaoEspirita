//
//  ProfileProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol ProfileViewToPresenterProtocol: class {
    
    var view: ProfilePresenterToViewProtocol? {get set}
    var interactor: ProfilePresenterToInteractorProtocol? {get set}
    var router: ProfilePresenterToRouterProtocol? {get set}
    
}

// Presenter -> View
protocol ProfilePresenterToViewProtocol: class {

}

// Presenter -> Router
protocol ProfilePresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol ProfilePresenterToInteractorProtocol: class {
    var presenter: ProfileInteractorToPresenterProtocol? {get set}
    
}

// Interactor -> Presenter
protocol ProfileInteractorToPresenterProtocol: class {

}
