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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var buttonMore: UIButton!
    @IBAction func btnMoreTapped(_ sender: Any) {
        
        if sender is UIButton {
            isExpanded = !isExpanded
            
            messageLabel.numberOfLines = isExpanded ? 0 : 2
            containerView.layer.cornerRadius = 12
            
            buttonMore.setTitle(isExpanded ? "Minimizar..." : "Ler mais...", for: .normal)
            
            delegate?.moreTapped(cell: self)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func myInit(theBody: String) {
        isExpanded = false

        messageLabel.text = theBody
        messageLabel.numberOfLines = 2
        
        containerView.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
