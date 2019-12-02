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
    
    func startFetchingBooks() {
        interactor?.fetchBooks()
    }
    
    func startFetchingVideos() {
        interactor?.checkStatusVideos()
    }
    
    func goToMidiaAllBooksScreen(navigationController: UINavigationController) {
        router?.pushToMidiaAllBooksScreen(navigationController: navigationController)
    }
    
    func goToMidiaAllVideosScreen(navigationController: UINavigationController) {
        router?.pushToMidiaAllVideosScreen(navigationController: navigationController)
    }
}

extension MidiaPresenter: MidiaInteractorToPresenterProtocol {

    func booksFetchedSuccess(bookModelArray: [BookModel]) {
        view?.showBooks(booksArray: bookModelArray)
    }
    
    func booksFetchFailed() {
        view?.showError()
    }
    
    func videosFetchedSuccess(videoModelArray: [VideoModel]) {
        view?.showVideos(videosArray: videoModelArray)
    }
    
    func videosFetchFailed() {
        view?.showError()
    }
}
