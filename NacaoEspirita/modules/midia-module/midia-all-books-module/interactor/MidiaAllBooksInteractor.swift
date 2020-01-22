//
//  MidiaAllBooksInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/20/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class MidiaAllBooksInteractor: MidiaAllBooksPresenterToInteractorProtocol {
    var presenter: MidiaAllBooksInteractorToPresenterProtocol?
    var bookArrayList = [BookModel]()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    func fetchBooks() {
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var bookArray = [BookModel]()
        
        db.collection("books").order(by: "name", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.booksFetchFailed(message: AppAlert.MESSAGE_BOOKS_FETCH_FAILED)
            } else {
                for document in querySnapshot!.documents {
                    bookArray.append(BookModel(document: document)!)
                }
                self.bookArrayList = bookArray
                self.presenter?.booksFetchedSuccess(bookModelArray: self.bookArrayList)
            }
        }
    }
}
