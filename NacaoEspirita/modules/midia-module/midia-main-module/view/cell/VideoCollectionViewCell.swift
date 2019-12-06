//
//  BookCollectionViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoContainer: UIView! {
        didSet {
            self.videoContainer.roundCorners(.allCorners, radius: 12)
        }
    }
    @IBOutlet weak var videoNamesLabel: UILabel!
    @IBOutlet weak var videoNameContainerView: UIView! {
        didSet {
            self.videoNameContainerView.roundCorners(.allCorners, radius: 10)
        }
    }
    @IBOutlet weak var videoDurationlabel: UILabel! {
        didSet {
            self.videoDurationlabel.roundCorners(.allCorners, radius: 3)
        }
    }
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView!  {
        didSet {
            self.videoImage.roundCorners(.allCorners, radius: 12)
        }
    }
    @IBOutlet weak var channelImage: UIImageView! {
        didSet {
            self.channelImage.roundCorners(.allCorners, radius: 15)
        }
    }
    @IBOutlet weak var channelContainerView: UIView! {
        didSet {
            self.channelContainerView.roundCorners(.allCorners, radius: 21)
        }
    }
    @IBOutlet weak var lineDashedHorizontalView: UIView! {
        didSet {
            self.lineDashedHorizontalView.addDashedBorder(width: 1, color: .lightGray, isVertical: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
}
