//
//  MidiaAllVideosPresenter.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

class MidiaAllVideosPresenter: MidiaAllVideosViewToPresenterProtocol {
    
    var view: MidiaAllVideosPresenterToViewProtocol?
    var interactor: MidiaAllVideosPresenterToInteractorProtocol?
    var router: MidiaAllVideosPresenterToRouterProtocol?
    
    func startFetchingVideos() {
        interactor?.fetchVideos()
    }
    
    func goToVideoDisplayScreen(navigationController: UINavigationController, id: String) {
        router?.pushToVideoDisplayScreen(navigationController: navigationController, id: id)
    }
}

extension MidiaAllVideosPresenter: MidiaAllVideosInteractorToPresenterProtocol {
    
    func videosFetchedSuccess(videoModelArray: [VideoModel]) {
        view?.showVideos(videosArray: videoModelArray)
    }
    
    func videosFetchFailed() {
        view?.showError()
    }
}
