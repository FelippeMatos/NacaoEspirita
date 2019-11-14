//
//  UITextField+BottomBorder.swift
//  Wellbe
//
//  Created by Felippe Matos Francoski on 12/17/18.
//  Copyright © 2018 Guilhermino Afonso. All rights reserved.
//

import UIKit

public extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
