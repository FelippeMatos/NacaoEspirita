//
//  HomeScheduleInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 14/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class HomeScheduleInteractor: HomeSchedulePresenterToInteractorProtocol {
    
    var presenter: HomeScheduleInteractorToPresenterProtocol?
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    func saveScheduleInFirebase(date: String) {
        
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            return
        }
        
        db.collection("evangelho").document("01").collection("schedule").document(userId).setData([
            "dateTime": date
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.presenter?.saveScheduleFailed(message: AppAlert.MESSAGE_SAVE_SCHEDULE_FAILED)
            } else {
                UserDefaults.standard.dateSchedulingOfEvangelhoNoLar = date
                self.presenter?.saveScheduleSuccess()
            }
        }
    }

    func deleteScheduleInFirebase() {
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            return
        }
                db.collection("evangelho").document("01").collection("schedule").document(userId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                
            } else {
                UserDefaults.standard.dateSchedulingOfEvangelhoNoLar = nil
                self.presenter?.deleteScheduleSuccess()
            }
        }
        
    }
}
