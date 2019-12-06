//
//  MessageTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class MessageProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.roundCorners(.allCorners, radius: 12)
        }
    }
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
