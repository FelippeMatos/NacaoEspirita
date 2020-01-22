//
//  MidiaAllBooksPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/20/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaAllBooksPresenter: MidiaAllBooksViewToPresenterProtocol {
    
    var view: MidiaAllBooksPresenterToViewProtocol?
    var interactor: MidiaAllBooksPresenterToInteractorProtocol?
    var router: MidiaAllBooksPresenterToRouterProtocol?
    
    func startFetchingBooks() {
        interactor?.fetchBooks()
    }
}

extension MidiaAllBooksPresenter: MidiaAllBooksInteractorToPresenterProtocol {
    
    func booksFetchedSuccess(bookModelArray: [BookModel]) {
        view?.showBooks(booksArray: bookModelArray)
    }
    
    func booksFetchFailed(message: String) {
        view?.showError(message: message)
    }
}
