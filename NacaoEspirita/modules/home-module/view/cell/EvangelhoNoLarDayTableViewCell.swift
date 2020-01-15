//
//  EvangelhoNoLarDayTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 15/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class EvangelhoNoLarDayTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
