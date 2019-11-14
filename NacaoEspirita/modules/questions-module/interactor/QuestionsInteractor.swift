//
//  QuestionsInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class QuestionsInteractor: QuestionsPresenterToInteractorProtocol {
    
    var presenter: QuestionsInteractorToPresenterProtocol?
    var questionArrayList = [QuestionModel]()
    var statusUserLikeArrayList = [Int]()
    var topAnswerArrayList = [AnswerModel]()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    
    var fetchLikeDone = false
    var fetchAnswerDone = false
    
    func fetchQuestions() {
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var questionArray = [QuestionModel]()
        
        db.collection("questions").order(by: "like", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.questionsFetchFailed()
            } else {
                for document in querySnapshot!.documents {
                    questionArray.append(QuestionModel(document: document)!)
                }
                self.questionArrayList = questionArray
                self.fetchUserLikes(questions: self.questionArrayList, userId: id)
                self.fetchTopAnswer(questions: self.questionArrayList, userId: id)
            }
        }
    }
    
    func fetchUserLikes(questions: [QuestionModel], userId: String) {
        
        var statusUserLikeArray = [Int](repeating: 0, count: questions.count)
        var count = [Int]()
        for (index, question) in questions.enumerated() {
            db.collection("questions").document(question.id!).collection("usersLike").document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let oldChoice = data!["like"] as? Bool
                    
                    if oldChoice! {
                        statusUserLikeArray[index] = 1
                        count.append(1)
                    } else {
                        statusUserLikeArray[index] = 2
                        count.append(2)
                    }
                } else {
                    statusUserLikeArray[index] = 0
                    count.append(0)
                }
                self.statusUserLikeArrayList = statusUserLikeArray
                if count.count == self.questionArrayList.count {
                    self.fetchLikeDone = true
                    self.completeFetchOfQuestions()
                }
            }
        }
    }
    
    func fetchTopAnswer(questions: [QuestionModel], userId: String) {
        
        var topAnswerArray = [AnswerModel](repeating: AnswerModel()!, count: questions.count)
//        var topAnswerArray = [AnswerModel]()
        var count = 0
        for (index, question) in questions.enumerated() {
            db.collection("questions").document(question.id!).collection("answer").order(by: "like", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
                for document in querySnapshot!.documents {
                    topAnswerArray[index] = AnswerModel(document: document)!
                }
                self.topAnswerArrayList = topAnswerArray
                count += 1
                if count == self.questionArrayList.count {
                    self.fetchAnswerDone = true
                    self.completeFetchOfQuestions()
                }
            }
        }
    }
    
    func completeFetchOfQuestions() {

        if fetchLikeDone && fetchAnswerDone {
            self.presenter?.questionsFetchedSuccess(questionsModelArray: self.questionArrayList, statusUserLikeArray: self.statusUserLikeArrayList, topAnswerArray: self.topAnswerArrayList)
        }
    }
    
    func checkStatusOfLike(_ like: Bool, questionId: String) {
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        db.collection("questions").document(questionId).collection("usersLike").document(id).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
            } else {
                if querySnapshot!.exists {
                    let data = querySnapshot!.data()
                    let oldChoice = data!["like"] as? Bool
                    
                    if oldChoice == like {
                        self.deleteRegisterUsersLike(questionId, userId: id, value: like)
                    } else {
                        self.updateRegisterUsersLike(questionId, userId: id, value: like)
                    }
                } else {
                    self.addNewRegisterUsersLike(questionId, userId: id, value: like)
                }
            }
        }

    }
    
    func addNewRegisterUsersLike(_ questionId: String, userId: String, value: Bool) {
        
        db.collection("questions").document(questionId).collection("usersLike").document(userId).setData([
            "like": value
        ]) { err in
            if let err = err {
                 print("Error adding document: \(err)")
            } else {
                self.updateLikeOfQuestionWith(value, questionId: questionId)
            }
        }
    }
    
    func updateLikeOfQuestionWith(_ value: Bool, questionId: String) {
        var like = 1
        if !value {
            like = -1
        }
        
        db.collection("questions").document(questionId).updateData([
            "like": FieldValue.increment(Int64(like))
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Success adding document!")
            }
        }
    }
    
    func updateRegisterUsersLike(_ questionId: String, userId: String, value: Bool) {
    
        db.collection("questions").document(questionId).collection("usersLike").document(userId).updateData([
            "like": value
        ]) { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                var like = 2
                if !value {
                    like = -2
                }
                
                self.db.collection("questions").document(questionId).updateData([
                    "like": FieldValue.increment(Int64(like))
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Success adding document!")
                    }
                }
            }
        }
    }
    
    func deleteRegisterUsersLike(_ questionId: String, userId: String, value: Bool) {
        
        db.collection("questions").document(questionId).collection("usersLike").document(userId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.updateLikeOfQuestionWith(!value, questionId: questionId)
            }
        }
    }
}
