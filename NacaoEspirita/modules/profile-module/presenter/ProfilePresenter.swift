//
//  ProfilePresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class ProfilePresenter: ProfileViewToPresenterProtocol {
    
    var view: ProfilePresenterToViewProtocol?
    var interactor: ProfilePresenterToInteractorProtocol?
    var router: ProfilePresenterToRouterProtocol?
    
}

extension ProfilePresenter: ProfileInteractorToPresenterProtocol {

}
