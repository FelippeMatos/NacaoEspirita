//
//  HomePresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/18/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter: HomeViewToPresenterProtocol {
    
    var view: HomePresenterToViewProtocol?
    var interactor: HomePresenterToInteractorProtocol?
    var router: HomePresenterToRouterProtocol?
    
    func chamarAlerta() {
        interactor?.verificarAlerta()
    }
}

extension HomePresenter: HomeInteractorToPresenterProtocol {
    
    func showAlerta() {
        view?.mostrarAlerta()
    }
}
