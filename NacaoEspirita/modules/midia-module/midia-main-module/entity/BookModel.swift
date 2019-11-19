//
//  BookModel.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/19/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase

private let ID = "key"
private let NAME = "name"
private let AUTHOR = "author"
private let LINK_BOOK = "link_book"
private let LINK_IMAGE = "link_image"

class BookModel {
    
    internal var id: String?
    internal var name: String?
    internal var author: String?
    internal var linkBook: String?
    internal var linkImage: String?
    
    required init?(document: QueryDocumentSnapshot) {
        mapping(document: document)
    }
    
    func mapping(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        let data = document.data()
        
        self.name = data[NAME] as? String
        self.author = data[AUTHOR] as? String
        self.linkBook = data[LINK_BOOK] as? String
        self.linkImage = data[LINK_IMAGE] as? String
    }
    
}
