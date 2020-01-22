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
    func startFetchingVideos()
    func goToMidiaAllBooksScreen(navigationController: UINavigationController)
    func goToMidiaAllVideosScreen(navigationController: UINavigationController)
}

// Presenter -> View
protocol MidiaPresenterToViewProtocol: class {
    func showBooks(booksArray: [BookModel])
    func showVideos(videosArray: [VideoModel])
    func showError(message: String)
}

// Presenter -> Router
protocol MidiaPresenterToRouterProtocol: class {
    func pushToMidiaAllBooksScreen(navigationController: UINavigationController)
    func pushToMidiaAllVideosScreen(navigationController: UINavigationController)
}

// Presenter -> Interactor
protocol MidiaPresenterToInteractorProtocol: class {
    var presenter: MidiaInteractorToPresenterProtocol? {get set}
    
    func fetchBooks()
    func checkStatusVideos()
}

// Interactor -> Presenter
protocol MidiaInteractorToPresenterProtocol: class {
    func booksFetchedSuccess(bookModelArray: [BookModel])
    func booksFetchFailed(message: String)
    func videosFetchedSuccess(videoModelArray: [VideoModel])
    func videosFetchFailed(message: String)
}

