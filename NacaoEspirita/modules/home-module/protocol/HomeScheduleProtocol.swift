//
//  HomeScheduleProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 14/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol HomeScheduleViewToPresenterProtocol: class {
    
    var view: HomeSchedulePresenterToViewProtocol? {get set}
    var interactor: HomeSchedulePresenterToInteractorProtocol? {get set}
    var router: HomeSchedulePresenterToRouterProtocol? {get set}
    
    func sendScheduleToPresenter(date: String)
    func deleteScheduleToPresenter()
}

// Presenter -> View
protocol HomeSchedulePresenterToViewProtocol: class {
    func showMessageOfSuccessAndDismiss()
    func showError(message: String)
}

// Presenter -> Router
protocol HomeSchedulePresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol HomeSchedulePresenterToInteractorProtocol: class {
    var presenter: HomeScheduleInteractorToPresenterProtocol? {get set}
    
    func saveScheduleInFirebase(date: String)
    func deleteScheduleInFirebase()
}

// Interactor -> Presenter
protocol HomeScheduleInteractorToPresenterProtocol: class {
    func saveScheduleSuccess()
    func saveScheduleFailed(message: String)
    func deleteScheduleSuccess()
}
