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
                self.presenter?.messageOfTheDayFetchFailed(message: AppAlert.MESSAGE_OF_THE_DAY_FETCH_FAILED)
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
    
    func fetchMessageOfEvangelho() {
        db.collection("evangelho").document("02").collection("messages").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.messageOfTheDayFetchFailed(message: AppAlert.MESSAGE_OF_THE_EVANGELHO_FETCH_FAILED)
            } else {
                let data = querySnapshot?.documents
                let number = Int.random(in: 0 ..< (data?.count)!)
                let selected = data![number].data()
                UserDefaults.standard.messageOfTheEvangelho = selected["message"] as? String
                UserDefaults.standard.authorMessageOfTheEvangelho = selected["author"] as? String
                self.presenter?.messageOfTheEvangelhoFetchedSuccess()
            }
        }
    }
}
