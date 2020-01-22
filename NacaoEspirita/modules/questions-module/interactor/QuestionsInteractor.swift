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
    var statusPinArrayList = [Bool]()
    var topAnswerArrayList = [AnswerModel]()
    let db = Firestore.firestore()
    
    var fetchLikeDone = false
    var fetchAnswerDone = false
    var fetchPinDone = false
    
    func fetchSavedQuestions() {
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var questionArray = [QuestionModel]()
        
        let ref = db.collection("questions").order(by: "like", descending: true)
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.questionsFetchFailed(message: AppAlert.MESSAGE_QUESTIONS_FETCH_SAVED_FAILED)
            } else {
                for document in querySnapshot!.documents {
                    questionArray.append(QuestionModel(document: document)!)
                }
                self.questionArrayList = questionArray
                self.fetchOnlyPin(questions: self.questionArrayList, userId: id)
            }
        }
    }
    
    func fetchOnlyPin(questions: [QuestionModel], userId: String) {
        
        var statusPinArray = [Bool](repeating: false, count: questions.count)
        var count = [Int]()
        for (index, question) in questions.enumerated() {
            db.collection("questions").document(question.id!).collection("pin").document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    statusPinArray[index] = true
                    count.append(1)
                } else {
                    self.questionArrayList.remove(at: index)
                    statusPinArray.remove(at: index)
                }
                self.statusPinArrayList = statusPinArray
                if count.count == self.questionArrayList.count {
                    self.fetchUserLikes(questions: self.questionArrayList, userId: userId)
                    self.fetchTopAnswer(questions: self.questionArrayList, userId: userId)
                    self.fetchPinDone = true
                    self.completeFetchOfQuestions()
                }
            }
        }
    }
    
    func fetchQuestions(_ all: Bool) {
        
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var questionArray = [QuestionModel]()
        
        var ref = db.collection("questions").order(by: "like", descending: true)
        if !all {
            ref = db.collection("questions").whereField("userId", isEqualTo: id)
        }
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
                self.presenter?.questionsFetchFailed(message: AppAlert.MESSAGE_ALL_QUESTIONS_FETCH_FAILED)
            } else {
                for document in querySnapshot!.documents {
                    questionArray.append(QuestionModel(document: document)!)
                }
                self.questionArrayList = questionArray
                self.fetchUserLikes(questions: self.questionArrayList, userId: id)
                self.fetchTopAnswer(questions: self.questionArrayList, userId: id)
                self.fetchPin(questions: self.questionArrayList, userId: id)
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
    
    func fetchPin(questions: [QuestionModel], userId: String) {
        
        var statusPinArray = [Bool](repeating: false, count: questions.count)
        var count = [Int]()
        for (index, question) in questions.enumerated() {
            db.collection("questions").document(question.id!).collection("pin").document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    statusPinArray[index] = true
                    count.append(1)
                } else {
                    statusPinArray[index] = false
                    count.append(0)
                }
                self.statusPinArrayList = statusPinArray
                if count.count == self.questionArrayList.count {
                    self.fetchPinDone = true
                    self.completeFetchOfQuestions()
                }
            }
        }
    }
    
    func completeFetchOfQuestions() {

        if fetchLikeDone && fetchAnswerDone && fetchPinDone {
            self.presenter?.questionsFetchedSuccess(questionsModelArray: self.questionArrayList, statusUserLikeArray: self.statusUserLikeArrayList, topAnswerArray: self.topAnswerArrayList, pinQuestionsArray: self.statusPinArrayList)
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
                    self.presenter?.pinSaveQuestionSuccess()
                }
            }
        } else {
            db.collection("questions").document(questionId).collection("pin").document(userId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.presenter?.pinDeleteQuestionSuccess(message: AppAlert.MESSAGE_PIN_QUESTION_DELETE_SUCCESS)
                }
            }
        }
    }
}
