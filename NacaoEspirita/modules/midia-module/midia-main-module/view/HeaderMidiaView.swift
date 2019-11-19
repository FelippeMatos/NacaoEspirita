//
//  HeaderMidiaView.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/19/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

protocol HeaderMidiaDelegate: class {
    func headerMidiaView(_ headerMidiaView: HeaderMidiaView, didTapButtonInSection section: Int)
}


class HeaderMidiaView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "HeaderMidiaView"
    
    weak var delegate: HeaderMidiaDelegate?
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    
    var sectionNumber: Int!  // you don't have to do this, but it can be useful to have reference back to the section number so that when you tap on a button, you know which section you came from; obviously this is problematic if you insert/delete sections after the table is loaded; always reload in that case
    
//    @IBAction func didTapButton(_ sender: AnyObject) {
//        delegate?.headerMidiaView(self, didTapButtonInSection: section)
//    }
}
