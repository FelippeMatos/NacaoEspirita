//
//  ChannelCollectionViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerImageView: UIView! {
        didSet {
            self.containerImageView.roundCorners(.allCorners, radius: 20)
        }
    }
    @IBOutlet weak var channelImageView: UIImageView! {
        didSet {
            self.channelImageView.roundCorners(.allCorners, radius: 18)
        }
    }
    @IBOutlet weak var maskChannelImageView: UIImageView! {
        didSet {
            self.maskChannelImageView.roundCorners(.allCorners, radius: 18)
        }
    }
    @IBOutlet weak var containerNameView: UIView! {
        didSet {
            self.containerNameView.roundCorners(.allCorners, radius: 6)
        }
    }
    @IBOutlet weak var channelNameLabel: UILabel! {
        didSet {
            self.channelNameLabel.layer.shadowColor = AppColor.ALMOST_WHITE.cgColor
            self.channelNameLabel.layer.shadowRadius = 2.0
            self.channelNameLabel.layer.shadowOpacity = 1.0
            self.channelNameLabel.layer.shadowOffset = CGSize(width: 0, height: -2)
            self.channelNameLabel.layer.masksToBounds = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
