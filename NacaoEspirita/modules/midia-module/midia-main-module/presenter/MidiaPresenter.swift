//
//  MidiaPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaPresenter: MidiaViewToPresenterProtocol {
    
    var view: MidiaPresenterToViewProtocol?
    var interactor: MidiaPresenterToInteractorProtocol?
    var router: MidiaPresenterToRouterProtocol?
    
}

extension MidiaPresenter: MidiaInteractorToPresenterProtocol {
    
}
