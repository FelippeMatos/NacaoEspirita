//
//  QuestionModel.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/24/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

private let ID = "key"
private let NAME = "name"
private let QUESTION = "question"
private let CATEGORY = "category"
private let LIKE = "like"

class QuestionModel {
    
    internal var id: String?
    internal var name: String?
    internal var question: String?
    internal var category: String?
    internal var like: Int?
    
    required init?(document: QueryDocumentSnapshot) {
        mapping(document: document)
    }
    
    func mapping(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        let data = document.data()
        
        self.name = data[NAME] as? String
        self.question = data[QUESTION] as? String
        self.category = data[CATEGORY] as? String
        self.like = data[LIKE] as? Int
    }
    
//    enum Category {
//        case allanKardec
//        case duvidasGerais
//        case cosmos
//        case other
//    }
    
}

//extension QuestionModel.Category: CaseIterable { }
//
//extension QuestionModel.Category: RawRepresentable {
//    typealias RawValue = String
//
//    init?(rawValue: RawValue) {
//        switch rawValue {
//        case "Allan Kardec": self = .allanKardec
//        case "Dúvidas Gerais": self = .duvidasGerais
//        case "Cosmos": self = .cosmos
//        case "Other": self = .other
//        default: return nil
//        }
//    }
//
//    var rawValue: RawValue {
//        switch self {
//        case .allanKardec: return "Allan Kardec"
//        case .duvidasGerais: return "Dúvidas Gerais"
//        case .cosmos: return "Cosmos"
//        case .other: return "Other"
//        }
//    }
//
//}
