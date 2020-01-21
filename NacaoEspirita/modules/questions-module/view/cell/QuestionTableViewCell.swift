//
//  TestTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/23/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionView: UIView! {
        didSet {
            self.questionView.roundCorners(.allCorners, radius: 10, borderWidth: 0, borderColor: .clear)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var buttonLikeTappedAction : ((UITableViewCell) -> Void)?
    var buttonDislikeTappedAction : ((UITableViewCell) -> Void)?

    @IBOutlet weak var pinButton: UIButton!
    var pinSaveTappedAction : ((UITableViewCell) -> Void)?
    var pinDeleteTappedAction : ((UITableViewCell) -> Void)?
    @IBAction func pinUpdateStateAction(_ sender: Any) {
        if self.pinButton.image(for: .normal) == UIImage(named: "icon-pin-off") {
            self.pinButton.setImage(UIImage(named: "icon-pin-on"), for: .normal)
            pinSaveTappedAction?(self)
        } else {
            self.pinButton.setImage(UIImage(named: "icon-pin-off"), for: .normal)
            pinDeleteTappedAction?(self)
        }
    }
    
    
    @IBOutlet weak var likeButton: UIButton!
    public func setLikeButton() {
        self.likeButton.setImage(UIImage(named: "icon-like-on"), for: .normal)
        self.dislikeButton.setImage(UIImage(named: "icon-dislike-off"), for: .normal)
    }
    
    @IBAction func likeAction(_ sender: AnyObject) {
        buttonLikeTappedAction?(self)
    }
    
    @IBOutlet weak var dislikeButton: UIButton!
    public func setDislikeButton() {
        self.dislikeButton.setImage(UIImage(named: "icon-dislike-on"), for: .normal)
        self.likeButton.setImage(UIImage(named: "icon-like-off"), for: .normal)
    }
    
    @IBAction func dislikeAction(_ sender: Any) {
        buttonDislikeTappedAction?(self)
    }
    
    public func turnOffButtons() {
        self.dislikeButton.setImage(UIImage(named: "icon-dislike-off"), for: .normal)
        self.likeButton.setImage(UIImage(named: "icon-like-off"), for: .normal)
    }
    
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
