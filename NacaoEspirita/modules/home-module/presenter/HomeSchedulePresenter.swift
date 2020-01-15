//
//  HomeSchedulePresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 14/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class HomeSchedulePresenter: HomeScheduleViewToPresenterProtocol {
    
    var view: HomeSchedulePresenterToViewProtocol?
    var interactor: HomeSchedulePresenterToInteractorProtocol?
    var router: HomeSchedulePresenterToRouterProtocol?
    let dateUtils = DateUtils()
 
    func sendScheduleToPresenter(date: String) {
        interactor?.saveScheduleInFirebase(date: date)
    }
    
    func deleteScheduleToPresenter() {
        interactor?.deleteScheduleInFirebase()
    }
}

extension HomeSchedulePresenter: HomeScheduleInteractorToPresenterProtocol {
    func deleteScheduleSuccess() {
        view?.showMessageOfSuccessAndDismiss()
    }
    
    func saveScheduleSuccess() {
        view?.showMessageOfSuccessAndDismiss()
    }
    
    func saveScheduleFailed() {
        view?.showError()
    }
    
    
}
