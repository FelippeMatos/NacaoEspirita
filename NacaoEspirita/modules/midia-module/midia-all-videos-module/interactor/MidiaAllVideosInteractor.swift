//
//  MidiaAllVideosInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class MidiaAllVideosInteractor: MidiaAllVideosPresenterToInteractorProtocol {
    var presenter: MidiaAllVideosInteractorToPresenterProtocol?
    var videoArrayList = [VideoModel]()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    func fetchVideos() {
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var videoArray = [VideoModel]()
        
        db.collection("videos").order(by: "publishedAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.videosFetchFailed()
            } else {
                for document in querySnapshot!.documents {
                    videoArray.append(VideoModel(document: document)!)
                }
                self.videoArrayList = videoArray
                self.presenter?.videosFetchedSuccess(videoModelArray: self.videoArrayList)
            }
        }
    }
}
