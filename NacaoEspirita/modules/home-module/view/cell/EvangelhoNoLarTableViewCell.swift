//
//  EvangelhoNoLarTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 12/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class EvangelhoNoLarTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    var moreAction : ((UITableViewCell) -> Void)?
    @IBAction func moreButtonAction(_ sender: Any) {
        moreAction?(self)
    }
    
    @IBOutlet weak var scheduleButton: UIButton!
    var scheduleAction : ((UITableViewCell) -> Void)?
    @IBAction func scheduleButtonAction(_ sender: Any) {
        scheduleAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 12
        scheduleButton.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
