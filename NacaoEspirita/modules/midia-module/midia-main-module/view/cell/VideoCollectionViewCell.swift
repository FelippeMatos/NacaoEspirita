//
//  BookCollectionViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoNamesLabel: UILabel!
    @IBOutlet weak var videoDurationlabel: UILabel! {
        didSet {
            self.videoDurationlabel.roundCorners(.allCorners, radius: 3)
        }
    }
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var channelImage: UIImageView! {
        didSet {
            self.channelImage.roundCorners(.allCorners, radius: 15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
