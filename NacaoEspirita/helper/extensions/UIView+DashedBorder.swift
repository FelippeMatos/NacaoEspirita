//
//  UIView+DashedBorder.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/1/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

public extension UIView {
    func addDashedBorder(width: CGFloat = 0, color: UIColor = .clear, isVertical: Bool) {
        DispatchQueue.main.async {
            self.layoutIfNeeded()

            //Create a CAShapeLayer
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = width
            // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
            shapeLayer.lineDashPattern = [2,3]
            
            let path = CGMutablePath()
            if isVertical {
                path.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: 0, y: self.frame.height)])
            } else {
                path.addLines(between: [CGPoint(x: 0, y: 0),
                                        CGPoint(x: self.frame.width, y: 0)])
            }
            
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
            
//            let shapeLayer = CAShapeLayer()
//            let frameSize = self.frame.size
//            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//
//            shapeLayer.bounds = shapeRect
//            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//            shapeLayer.fillColor = UIColor.clear.cgColor
//            shapeLayer.strokeColor = color.cgColor
//            shapeLayer.lineWidth = width
//            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
//            shapeLayer.lineDashPattern = [2,3]
//            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 1).cgPath
//
//            self.layer.addSublayer(shapeLayer)
        }
        

    }
}
