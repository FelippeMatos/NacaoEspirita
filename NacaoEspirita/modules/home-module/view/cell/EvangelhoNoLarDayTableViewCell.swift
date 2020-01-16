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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var modifyScheduleButton: UIButton!
    var modifyScheduleAction : ((UITableViewCell) -> Void)?
    @IBAction func modifyScheduleButtonAction(_ sender: Any) {
        modifyScheduleAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 12
        setTitle()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle() {
        
        let hourArray = UserDefaults.standard.dateSchedulingOfEvangelhoNoLar?.components(separatedBy: " ")
        let hour = hourArray?.last
        print("$$$$$$$$$$ VALOR: \(hour!)")
        
        titleLabel.text = "O Evangelho será hoje às \(hour!). \nNão se esqueça!"
    }

}
