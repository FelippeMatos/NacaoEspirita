//
//  MenuOptionTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class MenuOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImage.image = iconImage.image?.withRenderingMode(.alwaysTemplate)
        iconImage.tintColor = UIColor(named: "color-text-current")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
