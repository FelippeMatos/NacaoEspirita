//
//  MidiaBookDisplayPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/8/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaBookDisplayPresenter: MidiaBookDisplayViewToPresenterProtocol {
    
    var view: MidiaBookDisplayPresenterToViewProtocol?
    var interactor: MidiaBookDisplayPresenterToInteractorProtocol?
    var router: MidiaBookDisplayPresenterToRouterProtocol?
    
}

extension MidiaBookDisplayPresenter: MidiaBookDisplayInteractorToPresenterProtocol {
    
}
