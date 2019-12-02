//
//  VideoTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

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
    @IBOutlet weak var videoDurationlabel: UILabel!
    
    @IBOutlet weak var videoDurationContainerView: UIView! {
        didSet {
            self.videoDurationContainerView.roundCorners(.allCorners, radius: 3)
        }
    }
    @IBOutlet weak var lineDashedVertical2View: UIView! {
        didSet {
            self.lineDashedVertical2View.addDashedBorder(width: 1, color: .lightGray, isVertical: true)
        }
    }
    @IBOutlet weak var lineDashedVerticalView: UIView! {
        didSet {
            self.lineDashedVerticalView.addDashedBorder(width: 1, color: .lightGray, isVertical: true)
        }
    }
    @IBOutlet weak var lineDashedHorizontalView: UIView! {
        didSet {
            self.lineDashedHorizontalView.addDashedBorder(width: 1, color: .lightGray, isVertical: false)
        }
    }
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var videoImage: UIImageView! {
        didSet {
            self.videoImage.roundCorners(.allCorners, radius: 12)
        }
    }
    @IBOutlet weak var channelImage: UIImageView! {
        didSet {
            self.channelImage.roundCorners(.allCorners, radius: 20)
        }
    }
    @IBOutlet weak var channelContainerView: UIView! {
        didSet {
            self.channelContainerView.roundCorners(.allCorners, radius: 21)
        }
    }
    
    var videoTappedAction : ((UITableViewCell) -> Void)?
    @IBOutlet weak var videoButton: UIButton!
    @IBAction func videoActionButton(_ sender: Any) {
        videoTappedAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
