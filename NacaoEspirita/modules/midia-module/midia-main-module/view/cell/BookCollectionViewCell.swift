//
//  BookCollectionViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    
    var buttonTappedAction : ((UICollectionViewCell) -> Void)?
    @IBOutlet weak var testButton: UIButton!
    @IBAction func testAction(_ sender: AnyObject) {
        buttonTappedAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
