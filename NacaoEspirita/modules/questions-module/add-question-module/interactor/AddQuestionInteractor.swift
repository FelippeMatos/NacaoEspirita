//
//  AddQuestionInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/24/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class AddQuestionInteractor: AddQuestionPresenterToInteractorProtocol {
    var presenter: AddQuestionInteractorToPresenterProtocol?
    
    func validate(question: String) {
        
        if question == AppText.ADD_QUESTION_PLACEHOLDER {
            presenter?.sendError(message: "FAVOR PREENCHER")
            return
        }
        
        if question.count > 12 {
            saveQuestionInFirebase(question)
        } else {
            presenter?.sendError(message: "QUESTAO PEQUENA")
        }
        
    }
    
    func saveQuestionInFirebase(_ question: String) {
        
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        
        guard let name = Auth.auth().currentUser?.displayName, !name.isEmpty else {
            return
        }
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        let question: String = question
        let category: String = "geral"
        
        ref = db.collection("questions").addDocument(data: [
            "userId": id,
            "name": name,
            "question": question,
            "like": 0,
            "category": category
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                //TODO: MOSTRAR POPUP
                print("Document added with ID: \(ref!.documentID)")
                self.presenter?.saveQuestionDone()
            }
        }
    }
    
}
