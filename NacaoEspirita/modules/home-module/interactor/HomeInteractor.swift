//
//  HomeInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/18/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class HomeInteractor: HomePresenterToInteractorProtocol {
    var presenter: HomeInteractorToPresenterProtocol?
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    func fetchMessageOfTheDay() {
    
        db.collection("messages").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.messageOfTheDayFetchFailed()
            } else {
                let data = querySnapshot?.documents
                let number = Int.random(in: 0 ..< (data?.count)!)
                let selected = data![number].data()
                UserDefaults.standard.messageOfTheDay = selected["message"] as? String
                UserDefaults.standard.authorMessageOfTheDay = selected["author"] as? String
                self.presenter?.messageOfTheDayFetchedSuccess()
            }
        }
        
    }
}
