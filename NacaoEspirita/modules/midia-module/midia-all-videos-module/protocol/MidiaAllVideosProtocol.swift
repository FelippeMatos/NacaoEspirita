//
//  MidiaAllVideosProtocol.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

// View -> Presenter
protocol MidiaAllVideosViewToPresenterProtocol: class {
    
    var view: MidiaAllVideosPresenterToViewProtocol? {get set}
    var interactor: MidiaAllVideosPresenterToInteractorProtocol? {get set}
    var router: MidiaAllVideosPresenterToRouterProtocol? {get set}
    
    func startFetchingVideos()
    func goToVideoDisplayScreen(navigationController: UINavigationController, id: String)
}

// Presenter -> View
protocol MidiaAllVideosPresenterToViewProtocol: class {
    func showVideos(videosArray: [VideoModel])
    func showError()
}

// Presenter -> Router
protocol MidiaAllVideosPresenterToRouterProtocol: class {
    func pushToVideoDisplayScreen(navigationController: UINavigationController, id: String)
}

// Presenter -> Interactor
protocol MidiaAllVideosPresenterToInteractorProtocol: class {
    var presenter: MidiaAllVideosInteractorToPresenterProtocol? {get set}
    
    func fetchVideos()
}

// Interactor -> Presenter
protocol MidiaAllVideosInteractorToPresenterProtocol: class {
    func videosFetchedSuccess(videoModelArray: [VideoModel])
    func videosFetchFailed()
}

