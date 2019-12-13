//
//  MessageTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

protocol MessageProfileCellDelegate {
    func moreTapped(cell: MessageProfileTableViewCell)
}

class MessageProfileTableViewCell: UITableViewCell {

    var isExpanded: Bool = false
    var delegate: MessageProfileCellDelegate?
    var numberOfLines = 0
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var buttonMore: UIButton!
    @IBAction func btnMoreTapped(_ sender: Any) {
        
        if sender is UIButton {
            isExpanded = !isExpanded
            
            messageLabel.numberOfLines = isExpanded ? 0 : numberOfLines
            containerView.layer.cornerRadius = 12
            
            buttonMore.setTitle(isExpanded ? "minimizar..." : "mais...", for: .normal)
            
            delegate?.moreTapped(cell: self)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func myInit(message: String, author: String? = "", numberOfLines: Int, padding: Int, profile: Bool) {
        isExpanded = false

        messageLabel.text = message
        messageLabel.numberOfLines = numberOfLines
        authorLabel.text = author
        self.numberOfLines = numberOfLines
        
        containerLeadingConstraint.constant = CGFloat(padding)
        containerTrailingConstraint.constant = CGFloat(padding)
        containerBottomConstraint.constant = CGFloat(padding)
        containerTopConstraint.constant = CGFloat(padding)
        
        if profile {
            lineView.alpha = 0
            authorLabel.alpha = 0
            buttonTopConstraint.constant = 0.0
        }
        
        containerView.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
