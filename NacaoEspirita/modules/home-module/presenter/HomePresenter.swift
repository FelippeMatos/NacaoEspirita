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
    let dateUtils = DateUtils()
    
    func startFetchingMessageOfTheDay() {
        if UserDefaults.standard.dateMessageOfTheDay != nil {
            if UserDefaults.standard.dateMessageOfTheDay != dateUtils.currentDayString() {
                self.interactor?.fetchMessageOfTheDay()
            }
        } else {
            self.interactor?.fetchMessageOfTheDay()
        }
    }
}

extension HomePresenter: HomeInteractorToPresenterProtocol {
    func messageOfTheDayFetchedSuccess() {
        UserDefaults.standard.dateMessageOfTheDay = dateUtils.currentDayString()
        view?.showMessageOfTheDay()
    }
    
    func messageOfTheDayFetchFailed() {
        view?.showError()
    }
    
    
}
