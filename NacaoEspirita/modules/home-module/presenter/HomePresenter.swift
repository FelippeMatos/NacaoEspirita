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
    
    func goToScheduleEvangelhoScreen(view: HomeViewController, toSave: Bool) {
        router?.presentModalToScheduleEvangelhoScreen(view: view, toSave: toSave)
    }
    
    func checkIfIsNeedFetchMessage() {
        if UserDefaults.standard.dateSchedulingOfEvangelhoNoLar != nil {
            if compareDateScheduledWithDateNow() {
                if UserDefaults.standard.dateMessageOfTheEvangelho != dateUtils.currentDayString() {
                    self.interactor?.fetchMessageOfEvangelho()
                }
            }
        }
    }
    
    func compareDateScheduledWithDateNow() -> Bool {
        let daySaved = UserDefaults.standard.dateSchedulingOfEvangelhoNoLar?.components(separatedBy: "-")
        let daySavedPosition = dateUtils.getPositionWeekDay(daySaved![0])
        let dayWeekPosition = dateUtils.getPositionWeekDay(dateUtils.getTodayWeekDay())
        
        if daySavedPosition == dayWeekPosition {
            let savedHour = UserDefaults.standard.dateSchedulingOfEvangelhoNoLar?.components(separatedBy: " ")
            let currentHour = String(dateUtils.currentHour()) + ":00h"
            
            if currentHour >= (savedHour?.last)! {
                return false
            }
            return true
        }
        return false
    }
}

extension HomePresenter: HomeInteractorToPresenterProtocol {
    func messageOfTheDayFetchedSuccess() {
        UserDefaults.standard.dateMessageOfTheDay = dateUtils.currentDayString()
        view?.showMessageOfTheDay()
    }
    
    func messageOfTheEvangelhoFetchedSuccess() {
        UserDefaults.standard.dateMessageOfTheEvangelho = dateUtils.currentDayString()
        view?.showMessageOfTheDay()
    }
    
    func messageOfTheDayFetchFailed() {
        view?.showError()
    }
    
}
