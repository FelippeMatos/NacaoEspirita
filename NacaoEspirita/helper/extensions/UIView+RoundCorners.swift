//
//  UIView+RoundCorners.swift
//  Wellbe
//
//  Created by Felippe Matos Francoski on 12/17/18.
//  Copyright © 2018 Guilhermino Afonso. All rights reserved.
//

import UIKit


public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            
            // the layer used to draw the border
            let strokeLayer = CAShapeLayer()
            strokeLayer.frame = self.bounds
            strokeLayer.fillColor = UIColor.clear.cgColor
            strokeLayer.path = path.cgPath
            strokeLayer.strokeColor = borderColor.cgColor
            strokeLayer.lineWidth = borderWidth
            self.layer.addSublayer(strokeLayer)
        }
    }
}
