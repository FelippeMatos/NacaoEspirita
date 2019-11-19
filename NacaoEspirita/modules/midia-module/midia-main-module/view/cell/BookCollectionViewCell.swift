//
//  BookCollectionViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookContainerView: UIView! {
        didSet {
            self.bookContainerView.roundCorners(.allCorners, radius: 6)
        }
    }
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    var buttonTappedAction : ((UICollectionViewCell) -> Void)?
    @IBOutlet weak var bookButton: UIButton!
    @IBAction func bookAction(_ sender: AnyObject) {
        buttonTappedAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
