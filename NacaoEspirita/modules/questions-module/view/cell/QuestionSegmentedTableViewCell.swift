//
//  QuestionSegmentedTableViewCell.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 22/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class QuestionSegmentedTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            allTappedAction?(self)
        case 1:
            savedTappedAction?(self)
        default:
            mineTappedAction?(self)
        }
    }
    
    var allTappedAction : ((UITableViewCell) -> Void)?
    var savedTappedAction : ((UITableViewCell) -> Void)?
    var mineTappedAction : ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
