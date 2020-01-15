//
//  EvangelhoNoLarScheduledTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 15/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class EvangelhoNoLarScheduledTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var modifyScheduleButton: UIButton!
    var modifyScheduleAction : ((UITableViewCell) -> Void)?
    @IBAction func modifyScheduleButtonAction(_ sender: Any) {
        modifyScheduleAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        container.layer.cornerRadius = 12
        modifyScheduleButton.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
