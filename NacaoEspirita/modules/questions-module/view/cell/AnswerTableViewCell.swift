//
//  AnswerTableViewCell
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/23/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.roundCorners(.allCorners, radius: 20)
        }
    }
    @IBOutlet weak var containerView: UIView! 
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var centerBorderView: UIView! 
    
    var buttonLikeTappedAction : ((UITableViewCell) -> Void)?

    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likeAction(_ sender: AnyObject) {
        buttonLikeTappedAction?(self)
    }
    public func setLikeButton(isTrue: Bool) {
        if isTrue {
            self.likeButton.setImage(UIImage(named: "icon-heart-on"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named: "icon-heart-off"), for: .normal)
        }
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
