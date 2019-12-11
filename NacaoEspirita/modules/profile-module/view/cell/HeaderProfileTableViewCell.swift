//
//  HeaderProfileTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class HeaderProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageContainer: UIView! {
        didSet {
            self.profileImageContainer.roundCorners(.allCorners, radius: 12)
        }
    }
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.roundCorners(.allCorners, radius: 12)
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
