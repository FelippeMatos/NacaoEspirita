//
//  MidiaVideoDisplayProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol MidiaVideoDisplayViewToPresenterProtocol: class {
    
    var view: MidiaVideoDisplayPresenterToViewProtocol? {get set}
    var router: MidiaVideoDisplayPresenterToRouterProtocol? {get set}
    
}

// Presenter -> View
protocol MidiaVideoDisplayPresenterToViewProtocol: class {

}

// Presenter -> Router
protocol MidiaVideoDisplayPresenterToRouterProtocol: class {
    
}
