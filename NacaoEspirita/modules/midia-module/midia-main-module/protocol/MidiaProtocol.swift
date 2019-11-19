//
//  MidiaProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol MidiaViewToPresenterProtocol: class {
    
    var view: MidiaPresenterToViewProtocol? {get set}
    var interactor: MidiaPresenterToInteractorProtocol? {get set}
    var router: MidiaPresenterToRouterProtocol? {get set}
    
    func startFetchingBooks()
}

// Presenter -> View
protocol MidiaPresenterToViewProtocol: class {
    func showBooks(booksArray: [BookModel])
    func showError()
}

// Presenter -> Router
protocol MidiaPresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol MidiaPresenterToInteractorProtocol: class {
    var presenter: MidiaInteractorToPresenterProtocol? {get set}
    
    func fetchBooks()
}

// Interactor -> Presenter
protocol MidiaInteractorToPresenterProtocol: class {
    func booksFetchedSuccess(bookModelArray: [BookModel])
    func booksFetchFailed()
}

