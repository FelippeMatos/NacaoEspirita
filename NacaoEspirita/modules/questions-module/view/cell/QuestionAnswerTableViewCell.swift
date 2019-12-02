//
//  QuestionAnswerTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/3/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//
import UIKit

class QuestionAnswerTableViewCell: UITableViewCell {
    
    //QUESTION
    @IBOutlet weak var topBorderQuestionView: UIView! {
        didSet {
            self.topBorderQuestionView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: true)
        }
    }
    @IBOutlet weak var bottomBorderQuestionView: UIView! {
        didSet {
            self.bottomBorderQuestionView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: true)
        }
    }
    @IBOutlet weak var centerBorderQuestionView: UIView! {
        didSet {
            self.centerBorderQuestionView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: false)
        }
    }
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton! {
        didSet {
            self.answerButton.roundCorners(.allCorners, radius: 12, borderWidth: 0, borderColor: .clear)
        }
    }
    
    var buttonLikeTappedAction : ((UITableViewCell) -> Void)?
    var buttonDislikeTappedAction : ((UITableViewCell) -> Void)?
    var buttonPinTappedAction : ((UITableViewCell) -> Void)?
    
    var answerTappedWithFocusAction : ((UITableViewCell) -> Void)?
    @IBAction func goToAddAnswerWithFocusAction(_ sender: AnyObject) {
        answerTappedWithFocusAction?(self)
    }
    
    var answerTappedWithoutFocusAction : ((UITableViewCell) -> Void)?
    @IBAction func goToAddAnswerWithoutFocusAction(_ sender: Any) {
        answerTappedWithoutFocusAction?(self)
    }
    
    @IBOutlet weak var likeButton: UIButton!
    public func setLikeButton() {
        if self.likeButton.image(for: .normal) == UIImage(named: "icon-like-off") {
            self.likeButton.setImage(UIImage(named: "icon-like-on"), for: .normal)
            self.dislikeButton.setImage(UIImage(named: "icon-dislike-off"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named: "icon-like-off"), for: .normal)
            self.dislikeButton.setImage(UIImage(named: "icon-dislike-on"), for: .normal)
        }
    }
    
    @IBAction func likeAction(_ sender: AnyObject) {
        buttonLikeTappedAction?(self)
    }
    
    @IBOutlet weak var dislikeButton: UIButton!
    public func setDislikeButton() {
        if self.dislikeButton.image(for: .normal) == UIImage(named: "icon-dislike-off") {
            self.dislikeButton.setImage(UIImage(named: "icon-dislike-on"), for: .normal)
            self.likeButton.setImage(UIImage(named: "icon-like-off"), for: .normal)
        } else {
            self.dislikeButton.setImage(UIImage(named: "icon-dislike-off"), for: .normal)
            self.likeButton.setImage(UIImage(named: "icon-like-on"), for: .normal)
        }
    }
    
    @IBAction func dislikeAction(_ sender: Any) {
        buttonDislikeTappedAction?(self)
    }
    
    public func turnOffButtons() {
        self.dislikeButton.setImage(UIImage(named: "icon-dislike-off"), for: .normal)
        self.likeButton.setImage(UIImage(named: "icon-like-off"), for: .normal)
    }
    
    //ANSWER
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerNameLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.roundCorners(.allCorners, radius: 20)
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.roundCorners(.allCorners, radius: 12)
        }
    }
    
    @IBOutlet weak var topBorderView: UIView! {
        didSet {
            
            self.topBorderView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: true)
        }
    }
    
    @IBOutlet weak var bottomBorderView: UIView! {
        didSet {
            self.bottomBorderView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: true)
        }
    }
    
    @IBOutlet weak var centerBorderView: UIView! {
        didSet {
            self.centerBorderView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        turnOffButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
