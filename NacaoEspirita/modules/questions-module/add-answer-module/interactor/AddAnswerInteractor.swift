//
//  AddAnswerInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/25/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

class AddAnswerInteractor: AddAnswerPresenterToInteractorProtocol {
    
    var presenter: AddAnswerInteractorToPresenterProtocol?
    var answerArrayList = [AnswerModel]()
    var statusUserLikeArrayList = [Bool]()
    var statusPinQuestion = false
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    var fetchAnswersDone = false
    var fetchPinDone = false
    
    func validate(answer: String, id: String) {
        
        if answer == AppText.ADD_ANSWER_PLACEHOLDER {
            presenter?.sendError(message: "FAVOR PREENCHER")
            return
        }
        
        if answer.count > 12 {
            saveAnswerInFirebase(answer, id: id)
        } else {
            presenter?.sendError(message: "QUESTAO PEQUENA")
        }
        
    }
    
    func saveAnswerInFirebase(_ answer: String, id: String) {

        guard let name = Auth.auth().currentUser?.displayName, !name.isEmpty else {
            return
        }
        let question: String = answer
        let category: String = "geral"

        ref = db.collection("questions").document(id).collection("answer").addDocument(data: [
            "name": name,
            "answer": question,
            "category": category,
            "like": 0
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.presenter?.sendError(message: "ERRO PARA ENVIAR A RESPOSTA")
            } else {
                //TODO: MOSTRAR POPUP
                print("Document added with ID: \(self.ref!.documentID)")
                self.presenter?.saveAnswerDone()
            }
        }
    }
    
    //MARK: INITIAL FETCH
    func fetchAnswers(questionId: String) {
        var answerArray = [AnswerModel]()
        checkPinSituation(questionId)
        db.collection("questions").document(questionId).collection("answer").order(by: "like", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
//                self.presenter?.questionsFetchFailed()
            } else {
                for document in querySnapshot!.documents {
                    answerArray.append(AnswerModel(document: document)!)
                }
                self.answerArrayList = answerArray
                self.fetchUserLikes(answers: self.answerArrayList, questionId: questionId)
            }
        }
    }
    
    func checkPinSituation(_ questionId: String) {
       
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            return
        }
        
        db.collection("questions").document(questionId).collection("pin").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                self.statusPinQuestion = true
            } else {
                self.statusPinQuestion = false
            }
            self.fetchPinDone = true
            self.completeFetchOfAnswers()
        }
    }
    
    func fetchUserLikes(answers: [AnswerModel], questionId: String) {
        
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            return
        }
        
        var statusUserLikeArray = [Bool](repeating: false, count: answers.count)
        var count = [Int]()
        for (index, answer) in answers.enumerated() {
            db.collection("questions").document(questionId).collection("answer").document(answer.id!).collection("usersLike").document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    statusUserLikeArray[index] = true
                    count.append(1)
                } else {
                    statusUserLikeArray[index] = false
                    count.append(0)
                }
                self.statusUserLikeArrayList = statusUserLikeArray
                if count.count == self.answerArrayList.count {
                    self.fetchAnswersDone = true
                    self.completeFetchOfAnswers()
                }
            }
        }
    }
    
    func completeFetchOfAnswers() {

        if fetchAnswersDone && fetchPinDone {
            self.presenter?.answerFetchedSuccess(answerModelArray: self.answerArrayList, statusUserLikeArray: self.statusUserLikeArrayList, questionPin: self.statusPinQuestion)
        }
    }
    
    //MARK: QUESTION LIKE
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
    
    func updatePinQuestion(_ questionId: String, toSave: Bool) {
        
        guard let userId = Auth.auth().currentUser?.uid, !userId.isEmpty else {
            return
        }
        
        guard let name = Auth.auth().currentUser?.displayName, !name.isEmpty else {
            return
        }
        
        if toSave {
            db.collection("questions").document(questionId).collection("pin").document(userId).setData([
                "name": name
            ]) { err in
                if let err = err {
                     print("Error adding document: \(err)")
                } else {
                    self.presenter?.pinQuestionSuccess()
                }
            }
        } else {
            db.collection("questions").document(questionId).collection("pin").document(userId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.presenter?.pinQuestionFailed()
                }
            }
        }
    }
    
    //MARK: ANSWERS
    func checkStatusOfAnswerLike(_ like: Bool, questionId: String, answerId: String) {
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        db.collection("questions").document(questionId).collection("answer").document(answerId).collection("usersLike").document(id).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
            } else {
                if querySnapshot!.exists {
                    self.deleteRegisterUserAnswerLike(questionId, userId: id, answerId: answerId)
                } else {
                    self.addNewRegisterUserAnswerLike(questionId, userId: id, answerId: answerId)
                }
            }
        }
    }
    
    func deleteRegisterUserAnswerLike(_ questionId: String, userId: String, answerId: String) {
        db.collection("questions").document(questionId).collection("answer").document(answerId).collection("usersLike").document(userId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Success deleting document!")
                self.updateLikeOfAnswerWith(false, questionId: questionId, answerId: answerId)
            }
        }
    }
    
    func addNewRegisterUserAnswerLike(_ questionId: String, userId: String, answerId: String) {
        db.collection("questions").document(questionId).collection("answer").document(answerId).collection("usersLike").document(userId).setData([
            "like": true
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Success adding document!")
                self.updateLikeOfAnswerWith(true, questionId: questionId, answerId: answerId)
            }
        }
    }
    
    func updateLikeOfAnswerWith(_ value: Bool, questionId: String, answerId: String) {
        var like = 1
        if !value {
            like = -1
        }
        
        db.collection("questions").document(questionId).collection("answer").document(answerId).updateData([
            "like": FieldValue.increment(Int64(like))
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Success update like answer!")
            }
        }
    }
}

