//
//  AnswerModel.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/31/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

private let ID = "key"
private let NAME = "name"
private let ANSWER = "answer"
private let CATEGORY = "category"
private let LIKE = "like"

class AnswerModel {
    
    internal var id: String?
    internal var name: String?
    internal var answer: String?
    internal var category: String?
    internal var like: Int?
    
    init?(document: QueryDocumentSnapshot) {
        mapping(document: document)
    }
    
    init?(id: String? = nil, name: String? = nil, answer: String? = nil, category: String? = nil, like: Int? = nil) {
        self.id = id
        self.name = name
        self.answer = answer
        self.category = category
        self.like = like
    }
    
    func mapping(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        let data = document.data()
        
        self.name = data[NAME] as? String
        self.answer = data[ANSWER] as? String
        self.category = data[CATEGORY] as? String
        self.like = data[LIKE] as? Int
    }
    
}
