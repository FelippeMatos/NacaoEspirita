//
//  MidiaAllBooksProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/20/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol MidiaAllBooksViewToPresenterProtocol: class {
    
    var view: MidiaAllBooksPresenterToViewProtocol? {get set}
    var interactor: MidiaAllBooksPresenterToInteractorProtocol? {get set}
    var router: MidiaAllBooksPresenterToRouterProtocol? {get set}

    func startFetchingBooks()
}

// Presenter -> View
protocol MidiaAllBooksPresenterToViewProtocol: class {
    func showBooks(booksArray: [BookModel])
    func showError(message: String)
}

// Presenter -> Router
protocol MidiaAllBooksPresenterToRouterProtocol: class {
    
}

// Presenter -> Interactor
protocol MidiaAllBooksPresenterToInteractorProtocol: class {
    var presenter: MidiaAllBooksInteractorToPresenterProtocol? {get set}
    
    func fetchBooks()
}

// Interactor -> Presenter
protocol MidiaAllBooksInteractorToPresenterProtocol: class {
    func booksFetchedSuccess(bookModelArray: [BookModel])
    func booksFetchFailed(message: String)
}

